import UIKit
import Combine

protocol BaseViewModelType: AnyObject {
    var currentStepIndex: Int { get set }
    var steps: [BaseContent] { get }
    
    var currentStepIndexPublisher: Published<Int>.Publisher { get }
    var cancellables: Set<AnyCancellable> { get set }
}

// 기본 구현 추가 (선택 사항)
extension BaseViewModelType {
    var currentStep: BaseContent {
        return steps[currentStepIndex]
    }
}

class BaseViewController<ViewModel: BaseViewModelType>: UIViewController {
    
    let viewModel: ViewModel
    private var onNext: (() -> Void)?
    
    // 1. 제목
    lazy var mainTitleLabel: UILabel  = {
        let label = UILabel()
            label.textColor = UIColor(resource: .bblack)
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
        return label
    }()
    
    // 2. 부제목
    lazy var subTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = subTitle
        label.pretendardStyle = .body5
        label.textColor = UIColor(resource: .subtitle)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 3. 중앙 컨텐츠
    var contentView: UIView = UIView()
    
    // 4. 하단 고정 버튼
    lazy var actionButton: BasicButton = {
        let button = BasicButton(title: actionButtonTitle, status: .enabled)
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return button
    }()
    
    private var mainTitle: String = ""
    private let subTitle: String = ""
    private let actionButtonTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        setupLayout()
        bindViewModel()
    }
    
    init(viewModel: ViewModel, contentView: UIView = UIView(), onNext: (() -> Void)?) {
        self.viewModel = viewModel
        self.contentView = contentView
        self.onNext = onNext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(contentView)
        view.addSubview(actionButton)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large.value),
            mainTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large.value),
            
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large.value),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large.value),
            
            contentView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large.value),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large.value),
            contentView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16),
            
            actionButton.heightAnchor.constraint(equalToConstant: ButtonSize.large.height),
            actionButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor , constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Spacing.large.value),
        ])
    }
    
    private func bindViewModel() {
        viewModel.currentStepIndexPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newIndex in
                guard let self = self else { return }
                self.updateUI()
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Update UI
    private func updateUI() {
        let step = viewModel.currentStep
        mainTitleLabel.setTextWithLineSpacing(step.mainTitle, style: .head1, lineHeightMultiple: 1.6)
        subTitleLabel.setTextWithLineSpacing(step.subTitle, style: .body5, lineHeightMultiple: 1.6)
        actionButton.setTitle(step.actionButtonTitle, for: .normal)
    }
    
    func SubStackView(label: UILabel, view: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label, view])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
    
    @objc private func nextStep() {
        onNext?()
    }
    
    private func updateActionButtonState(_ isEnabled: Bool) {
        actionButton.isEnabled = isEnabled
        actionButton.status = isEnabled ? .enabled : .enabled
    }
}


