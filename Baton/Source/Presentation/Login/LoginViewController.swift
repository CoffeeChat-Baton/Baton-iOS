import AuthenticationServices
import UIKit
import Combine

class LoginViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    private let viewModel: LoginViewModel
    private var pages: [UIViewController] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bwhite
        setupPages()
        bindViewModel()
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.hideTabBar()
        }
        setupLoginNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    private func setupLoginNavigationBar() {
        let skipButton = UIBarButtonItem(
            title: "건너뛰기",
            style: .plain,
            target: self,
            action: #selector(skipButtonTapped)
        )
        navigationItem.rightBarButtonItem = skipButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = UIColor.clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func skipButtonTapped() {
        viewModel.goToLogin()
    }
    
    private func setupPages() {
        let blueBackground = UIView()
        blueBackground.backgroundColor = UIColor(hex: "#CADDFF")
        
        let whiteBackground = UIView()
        whiteBackground.backgroundColor = .bwhite
        
        let imageBackground = UIImageView(image: UIImage(resource: .onboarding2Background))
        imageBackground.contentMode = .scaleAspectFill
        
        let loginImageBackground = UIImageView(image: UIImage(resource: .loginBackground))
        loginImageBackground.contentMode = .scaleAspectFill
        
        let backgroundViews: [UIView] = [blueBackground, imageBackground, imageBackground, loginImageBackground]
        let fileNames: [String] = ["onboarding_1", "", "", ""]
        
        pages = backgroundViews.enumerated().map { index, background in
            let fileName = fileNames[index]
            
            return LoginCommonViewController(
                viewModel: viewModel,
                backgroundView: background,
                fileName: fileName,
                onNext: index == backgroundViews.count - 1
                ? { self.handleAppleSignIn()}
                : { self.viewModel.goToNextStep() } 
            )
        }
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    private func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func bindViewModel() {
        viewModel.$currentStepIndex
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self, index < self.pages.count else { return }
                self.setViewControllers([self.pages[index]], direction: .forward, animated: true, completion: nil)
                print(index)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Apple 로그인 Delegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.givenName ?? "Unknown"
            let email = appleIDCredential.email ?? "No Email"
            
            print("User ID: \(userIdentifier)")
            print("Full Name: \(fullName)")
            print("Email: \(email)")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple 로그인 실패: \(error.localizedDescription)")
    }
}

// MARK: - UI 설정
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
