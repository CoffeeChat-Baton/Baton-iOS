import UIKit

protocol SelectionModalDelegate: AnyObject {
    associatedtype SelectionType
    func didSelectOption(_ option: String, type: SelectionType)
}

class SelectionModal<T, D: SelectionModalDelegate>: UIViewController where D.SelectionType == T {
    // MARK: - Properties
    weak var delegate: D?
    private let selectionType: T
    private let modalView = UIView()
    //    private let titleLabel = UILabel()
    //    private let closeButton = UIButton(type: .system)
    private let optionsScrollView = UIScrollView()
    private let optionsStackView = UIStackView()
    private var modalHeightConstraint: NSLayoutConstraint?
    
    private let headerView: ModalHeaderView
    private let options: [String]
    private var selectedOption: String?
    private var optionButtons: [UIButton] = []
    
    // MARK: - Init
    init(headerTitle: String, options: [String], selectionType: T, delegate: D, selectedOption: String?) {
        self.headerView = ModalHeaderView(title: headerTitle)
        self.options = options
        self.selectionType = selectionType
        self.delegate = delegate
        self.selectedOption = selectedOption
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubViews()
        setupConstraint()
        setupAction()
        updateData()
        animateModalAppearance()
    }
    
    // MARK: - UI Setup
    private func addSubViews() {
        view.addSubview(modalView)
        modalView.addSubview(headerView)
        modalView.addSubview(optionsScrollView)
        optionsScrollView.addSubview(optionsStackView)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        optionsScrollView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 16
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        optionsScrollView.alwaysBounceVertical = true
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 8
    }
    
    private func setupConstraint() {
        modalHeightConstraint = modalView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        modalHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: modalView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),
            
            optionsScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            optionsScrollView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            optionsScrollView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            optionsScrollView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),
            
            optionsStackView.widthAnchor.constraint(equalTo: optionsScrollView.frameLayoutGuide.widthAnchor),
            optionsStackView.topAnchor.constraint(equalTo: optionsScrollView.topAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: optionsScrollView.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: optionsScrollView.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: optionsScrollView.bottomAnchor)
        ])
    }
    
    private func setupAction(){
        headerView.onCloseTapped = { [weak self] in
            self?.dismissModal()
        }
        
    }
    
    // MARK: - Load Options
    private func updateData() {
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        optionButtons.removeAll() // ✅ 기존 버튼 초기화
        
        options.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.bblack, for: .normal) // 기본 색상 (비선택)
            button.contentHorizontalAlignment = .left // ✅ 텍스트 왼쪽 정렬
            button.titleLabel?.font = UIFont.Pretendard.body4.font // ✅ Pretendard 폰트 적용

            // ✅ 체크 이미지 추가 (오른쪽 끝에 배치)
            let checkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
            checkImageView.tintColor = .bblack
            checkImageView.translatesAutoresizingMaskIntoConstraints = false
            checkImageView.isHidden = option != selectedOption // ✅ 선택된 옵션만 체크 표시

            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(button)
            containerView.addSubview(checkImageView)

            // ✅ 버튼 & 체크 이미지 위치 조정 (버튼이 꽉 차도록)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: checkImageView.leadingAnchor, constant: -8),
                button.topAnchor.constraint(equalTo: containerView.topAnchor),
                button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

                checkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                checkImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor), // ✅ 가장 오른쪽 정렬
                checkImageView.widthAnchor.constraint(equalToConstant: 20),
                checkImageView.heightAnchor.constraint(equalToConstant: 20)
            ])

            // ✅ 버튼 클릭 시 체크 상태 변경
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)

            optionButtons.append(button) // ✅ 버튼 리스트에 추가
            optionsStackView.addArrangedSubview(containerView)

            // ✅ 버튼 높이 지정
            containerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            containerView.widthAnchor.constraint(equalTo: optionsStackView.widthAnchor).isActive = true
        }
        
        let estimatedHeight = CGFloat(80 + (options.count * (48 + 8)))
        let maxHeight = view.frame.height * 0.9
        modalHeightConstraint?.constant = min(estimatedHeight, maxHeight)
    }
    
    // MARK: - Button Actions
    @objc private func optionSelected(_ sender: UIButton) {
        guard let selectedText = sender.titleLabel?.text else { return }

        // ✅ 모든 버튼 체크 해제
        for button in optionButtons {
            var config = button.configuration
            config?.image = nil
            button.configuration = config
            button.setTitleColor(.gray3, for: .normal)
        }

        // ✅ 현재 선택한 버튼만 체크
        var selectedConfig = sender.configuration
        selectedConfig?.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        sender.configuration = selectedConfig
        sender.setTitleColor(.bblack, for: .selected)

        selectedOption = selectedText // ✅ 선택한 옵션 저장
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

