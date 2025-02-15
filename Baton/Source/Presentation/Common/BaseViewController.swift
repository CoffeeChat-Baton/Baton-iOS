import UIKit

class BaseViewController: UIViewController {
    
    // 1. 제목
    lazy var mainTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = mainTitle
        label.font = UIFont.boldSystemFont(ofSize: 22) // TODO: head1으로 수정
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
        label.font = UIFont.boldSystemFont(ofSize: 14) // TODO: body4으로 수정
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mainTitle: String
    private let subTitle: String
    private let actionButtonTitle: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        setupLayout()
    }
    
    init(mainTitle: String, subTitle: String, actionButtonTitle: String, contentView: UIView) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.actionButtonTitle = actionButtonTitle
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.mainTitle = "기본 타이틀"
        self.subTitle = "기본 서브 타이틀"
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
            actionButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -52),
            actionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor , constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Spacing.large.value),
        ])
    }
}


