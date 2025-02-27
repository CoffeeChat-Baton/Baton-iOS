import UIKit

/// 바통앱만의 네비게이션 바 스타일 적용 가능
protocol BatonNavigationConfigurable: AnyObject {
    func setupBatonNavigationBar(title: String, backButton: UIBarButtonItem)
    
    func backButtonTapped()
}

extension BatonNavigationConfigurable where Self: UIViewController {
    func setupBatonNavigationBar(title: String, backButton: UIBarButtonItem) {

        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = title
        navigationItem.titleView?.tintColor = .bblack
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
