import UIKit

protocol SelectionModalDelegate: AnyObject {
    func didSelectOption(_ option: String, type: CheckProfileViewModel.SelectionType)
}

class SelectionModal: UIViewController {
    
    // MARK: - Properties
    weak var delegate: SelectionModalDelegate?
    private let viewModel: CheckProfileViewModel
    private let selectionType: CheckProfileViewModel.SelectionType
    
    private let modalView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let optionsStackView = UIStackView()
    private var modalHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    init(viewModel: CheckProfileViewModel, selectionType: CheckProfileViewModel.SelectionType) {
        self.viewModel = viewModel
        self.selectionType = selectionType
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical // ✅ 아래에서 올라오는 스타일 적용
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadOptions()
        animateModalAppearance() // ✅ 애니메이션 추가
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // ✅ 모달 배경 뷰 설정
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 16
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // ✅ 위쪽만 둥글게
        modalView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modalView)
        
        // ✅ 닫기 버튼 (X)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let closeImage = UIImage(systemName: "xmark", withConfiguration: configuration)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        // ✅ 타이틀 설정
        titleLabel.text = viewModel.getTitle(for: selectionType)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.Pretendard.title1.font
        titleLabel.textColor = .black
        
        // ✅ 옵션 리스트 (버튼들) 스택 뷰 설정
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 8
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // ✅ 닫기 버튼 + 타이틀을 포함한 헤더 뷰
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal) // 중앙 정렬을 위해 우선순위 낮춤
        let headerStackView = UIStackView(arrangedSubviews: [closeButton, spacerView, titleLabel, spacerView])
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.spacing = 15
        headerStackView.translatesAutoresizingMaskIntoConstraints = false

        modalView.addSubview(headerStackView)
        modalView.addSubview(optionsStackView)
        
        // ✅ 레이아웃 설정
        modalHeightConstraint = modalView.heightAnchor.constraint(equalToConstant: 200) // 초기값
        
        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modalHeightConstraint!, // ✅ 높이 조절 가능
            
            headerStackView.heightAnchor.constraint(equalToConstant: 52),
            headerStackView.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 5),
            headerStackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            headerStackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            optionsStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 15),
            optionsStackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            optionsStackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            optionsStackView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15)
        ])
    }
    
    // MARK: - Load Options
    private func loadOptions() {
        let options = viewModel.getOptions(for: selectionType)
        updateOptions(options)
    }
    
    private func updateOptions(_ options: [String]) {
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        options.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.pretendardStyle = .body4
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
        }
        
        // ✅ 옵션 개수에 따라 모달 높이 동적 조절
        let estimatedHeight = CGFloat(80 + (options.count * (48 + 8))) // 헤더(80) + 버튼(48*옵션 수)
        let maxHeight = view.frame.height * 0.9 // ✅ 최대 높이: 화면의 60%
        modalHeightConstraint?.constant = min(estimatedHeight, maxHeight)
    }
    
    // MARK: - Button Actions
    @objc private func optionSelected(_ sender: UIButton) {
        guard let selectedText = sender.titleLabel?.text else { return }
        delegate?.didSelectOption(selectedText, type: selectionType)
        dismissModal()
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.modalView.transform = CGAffineTransform(translationX: 0, y: self.modalView.frame.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: - Modal Animation
    private func animateModalAppearance() {
        modalView.transform = CGAffineTransform(translationX: 0, y: modalView.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.modalView.transform = .identity
        }
    }
}
