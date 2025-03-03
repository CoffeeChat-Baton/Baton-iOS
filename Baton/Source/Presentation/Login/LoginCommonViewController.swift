import Combine
import UIKit
import Lottie

class LoginCommonViewController: BaseViewController<LoginViewModel> {
    
    private let backgroundView: UIView
    private var lottieFileName: String = ""
    
    private lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: self.lottieFileName )
        view.contentMode = .scaleAspectFill
        view.loopMode = .loop // 무한 반복
        view.animationSpeed = 1.0 // 애니메이션 속도 조절
        return view
    }()

    init(viewModel: LoginViewModel, backgroundView: UIView, fileName: String, onNext: @escaping () -> Void)  {
        self.backgroundView = backgroundView
        self.lottieFileName = fileName
        super.init(viewModel: viewModel, contentView: UIView(), onNext: onNext)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimationView()
        actionButton.backgroundColor = .bblack
    }
    
    private func setupUI() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView) // 가장 아래로 배치

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupAnimationView(){
        guard !lottieFileName.isEmpty else { // 파일명 없는 경우 보여주지 않음.
            animationView.isHidden = true
            return
        }
        
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(lessThanOrEqualTo: actionButton.topAnchor)
        ])
        
    }
}
