import UIKit
import Lottie

class SuccessViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success_background") // 이미지 설정
        imageView.contentMode = .scaleAspectFill // 화면에 꽉 차게 설정
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // ✅ 아이콘 이미지
    private let iconImageView: LottieAnimationView = {
        let view = LottieAnimationView(name: "check_motion")
        view.frame = CGRect(x: 0, y: 0, width: 84, height: 84)
        
        view.contentMode = .scaleAspectFill
        view.loopMode = .loop // 무한 반복
        view.animationSpeed = 1.2 // 애니메이션 속도 조절
        return view
    }()
    
    // ✅ 타이틀
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(resource: .bblack)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ✅ 서브타이틀
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray5
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ✅ 버튼 1 (ex: "멘토 정보 확인하기")
    private let primaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.main, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ✅ 버튼 2 (ex: "확인")
    private let secondaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.main
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ✅ StackView로 UI 정리
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // ✅ 아이콘 + 라벨을 담는 스택뷰
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // ✅ 그라디언트 배경 뷰
    private let gradientBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var primaryAction: (() -> Void)?
    private var secondaryAction: (() -> Void)?
    
    // ✅ 초기화
    init(title: String, subtitle: String, icon: UIImage? = nil, primaryButtonText: String, secondaryButtonText: String, primaryAction: (() -> Void)?, secondaryAction: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        if primaryButtonText.isEmpty {
            primaryButton.isHidden = true
        }
        titleLabel.text = title
        subtitleLabel.text = subtitle
        primaryButton.setTitle(primaryButtonText, for: .normal)
        secondaryButton.setTitle(secondaryButtonText, for: .normal)
        
        // 버튼 클릭 액션 설정
        primaryButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        
        setupGradientBackground()
        setupLayout()
        
        iconImageView.play()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) // 다른 화면에서 다시 보이도록 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // ✅ 버튼 액션
    @objc private func primaryButtonTapped() {
        primaryAction?()
    }
    
    @objc private func secondaryButtonTapped() {
        secondaryAction?()
    }
    
    
    
    // ✅ 레이아웃 설정
    private func setupLayout() {
        //        view.addSubview(gradientBackgroundView)
        view.insertSubview(backgroundImageView, at: 0) // 배경을 가장 아래에 삽입
        view.addSubview(contentStackView)
        view.addSubview(buttonStackView)
        
        // 스택뷰에 요소 추가
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        
        buttonStackView.addArrangedSubview(primaryButton)
        buttonStackView.addArrangedSubview(secondaryButton)
        
        NSLayoutConstraint.activate([
            
            iconImageView.widthAnchor.constraint(equalToConstant: 140),
            iconImageView.heightAnchor.constraint(equalToConstant: 140),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ✅ 아이콘 & 라벨을 포함한 스택뷰 (뷰 중앙 정렬)
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40), // 약간 위로 이동
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // ✅ 버튼 스택뷰 (뷰 하단 고정)
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // ✅ 버튼 높이
            primaryButton.heightAnchor.constraint(equalToConstant: 50),
            secondaryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // ✅ 그라디언트 배경 설정
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.cgColor, // 상단 흰색
            UIColor(red: 224/255, green: 235/255, blue: 255/255, alpha: 1.0).cgColor // 마지막 E0EBFF 적용
        ]
        gradientLayer.locations = [0.0, 1.0]  // 👉 85%까지 흰색 유지, 이후 E0EBFF 전환
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 중앙 위에서 시작
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // 중앙 아래로 끝
        gradientLayer.frame = view.bounds
        
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

