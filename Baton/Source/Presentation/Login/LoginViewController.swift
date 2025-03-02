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
    }

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.hideTabBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    private func setupPages() {
        let step1 = UIViewController()
        let step2 = UIViewController()
        pages = [step1, step2]
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    private func bindViewModel() {
        viewModel.$currentStepIndex
            .dropFirst() // 첫 번째 값 무시 (초기 상태 방지)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self, index < self.pages.count else { return }
                self.setViewControllers([self.pages[index]], direction: .forward, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}
