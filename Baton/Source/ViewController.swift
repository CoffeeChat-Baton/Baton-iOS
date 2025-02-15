import UIKit

class ViewController: UIViewController {
    let basicButtonTitle = "파트너 등록 신청하기"
    let basicButtonHeightSize: CGFloat = CGFloat(52)
    let basicButtonConstant: CGFloat = CGFloat(22)
    let basicButtonBottomConstant: CGFloat = CGFloat(51)
    
    lazy var basicButton: BasicButton = {
        let button = BasicButton(title: basicButtonTitle, status: .enabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleString: String
    private let subTitleString: String

    lazy var mainTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = titleString
        label.font = UIFont.boldSystemFont(ofSize: 22) // TODO: head1으로 수정
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = subTitleString
        label.font = UIFont.boldSystemFont(ofSize: 14) // TODO: body4으로 수정
        label.textColor = UIColor(resource: .subtitle)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        setupLayout()
    }
    
    init(titleString: String, subTitleString: String) {
        self.titleString = titleString
        self.subTitleString = subTitleString
        super.init(nibName: nil, bundle: nil) // ✅ UIViewController 초기화

    }
    
    required init?(coder: NSCoder) {
        self.titleString = "기본 타이틀"
        self.subTitleString = "기본 서브 타이틀"
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        view.addSubview(basicButton)
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        
        
    }
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            basicButton.heightAnchor.constraint(equalToConstant: basicButtonHeightSize),
            basicButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -basicButtonBottomConstant),
            basicButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor , constant: basicButtonConstant),
            basicButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -basicButtonConstant),

            mainTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: basicButtonConstant),
            mainTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicButtonConstant),
            
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: basicButtonConstant),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicButtonConstant)
        ])
    }
    
    
}

