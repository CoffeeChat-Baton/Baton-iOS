import UIKit

class BatonTabBarController: UITabBarController {
    private let customTabBar = BatonTabBar(items: [
        ("홈", UIImage(named: "home")),
        ("바통", UIImage(named: "baton")),
        ("마이", UIImage(named: "mypage"))
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupCustomTabBar()
    }
    
    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let batonVC = UINavigationController(rootViewController: MyBatonViewController())
        let myPageVC = UINavigationController(rootViewController: MyPageViewController())
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)
        batonVC.tabBarItem = UITabBarItem(title: "바통", image: UIImage(named: "baton"), tag: 1)
        myPageVC.tabBarItem = UITabBarItem(title: "마이", image: UIImage(named: "mypage"), tag: 2)
        
        self.viewControllers = [homeVC, batonVC, myPageVC]
    }
    
    private func setupCustomTabBar() {
        // 기본 탭바 숨기기
        tabBar.isHidden = true
        
        // 커스텀 탭바 추가
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
        
        customTabBar.delegate = self
    }
    
    /// ✅ 커스텀 탭바 델리게이트
    func switchToTab(index: Int) {
        selectedIndex = index
    }
    
    /// ✅ 탭바 완전히 숨기기 (isHidden 활용)
    func hideTabBar() {
        UIView.animate(withDuration: 0.3) {
            self.customTabBar.alpha = 0
            self.customTabBar.isHidden = true // ✅ 아예 보이지 않게
        }
    }

    /// ✅ 탭바 다시 보이기
    func showTabBar() {
        guard self.customTabBar.isHidden else { return } // ✅ 중복 실행 방지

        self.customTabBar.isHidden = false // ✅ 다시 보이게 설정
        UIView.animate(withDuration: 0.3) {
            self.customTabBar.alpha = 1
        }
    }
}

// ✅ 커스텀 탭바 델리게이트 적용
extension BatonTabBarController: BatonTabBarDelegate {
    func tabBarDidSelect(index: Int) {
        switchToTab(index: index)
    }
}
