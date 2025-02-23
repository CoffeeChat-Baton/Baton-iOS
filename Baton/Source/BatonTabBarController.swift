import UIKit

extension BatonTabBarController: BatonTabBarDelegate {
    func tabBarDidSelect(index: Int) {
        switchToViewController(index: index)
    }
}

class BatonTabBarController: UIViewController {
    private let tabItems: [(title: String, image: UIImage?)] = [
        ("홈", UIImage(named: "home")),
        ("바통", UIImage(named: "baton")),
        ("마이", UIImage(named: "mypage"))
    ]
    private lazy var batonTabBar = BatonTabBar(items: tabItems)
    private let viewControllers: [UIViewController]
    
    private var currentViewController: UIViewController?
    
    init() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let batonVC = UINavigationController(rootViewController: HomeViewController())
        let myPageVC = UINavigationController(rootViewController: HomeViewController())
        
        self.viewControllers = [homeVC, batonVC, myPageVC]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        switchToViewController(index: 0)
    }
    
    private func setupTabBar() {
        view.addSubview(batonTabBar)
        
        batonTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            batonTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            batonTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            batonTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            batonTabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func switchToViewController(index: Int) {
        if let currentVC = currentViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        let newVC = viewControllers[index]
        addChild(newVC)
        view.insertSubview(newVC.view, belowSubview: batonTabBar)
        newVC.didMove(toParent: self)
        
        currentViewController = newVC
    }
}
