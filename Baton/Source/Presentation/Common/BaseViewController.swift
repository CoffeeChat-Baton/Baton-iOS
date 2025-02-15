import UIKit

class BaseViewController: UIViewController {
    
    let viewModel: PartnerRegistrationViewModel
    private var onNext: (() -> Void)?
    
    // 1. 제목
    lazy var mainTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = mainTitle
        label.pretendardStyle = .head1
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 2. 부제목
    lazy var subTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = subTitle
        label.pretendardStyle = .body5
        label.textColor = UIColor(resource: .subtitle)
        label.textAlignment = .left
        label.numberOfLines = 2
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
    
    private let mainTitle: String = ""
    private let subTitle: String = ""
    private let actionButtonTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        setupLayout()
        bindViewModel()
        
    }
    
    init(viewModel: PartnerRegistrationViewModel, contentView: UIView = UIView(), onNext: (() -> Void)?) {
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
        viewModel.$currentStepIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.mainTitleLabel.text = self.viewModel.currentStep.mainTitle
                self.subTitleLabel.text = self.viewModel.currentStep.subTitle
                self.actionButton.setTitle(self.viewModel.currentStep.actionButtonTitle, for: .normal)
            }
            .store(in: &viewModel.cancellables)
    }
    
    @objc private func nextStep() {
        onNext?()
    }
    
    private func updateActionButtonState(_ isEnabled: Bool) {
        actionButton.isEnabled = isEnabled
        actionButton.status = isEnabled ? .enabled : .enabled
    }
}


