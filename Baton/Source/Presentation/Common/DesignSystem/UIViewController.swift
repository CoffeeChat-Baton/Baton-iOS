import UIKit

extension UIViewController {
    
    func setupBatonNavigationBar(isHome: Bool = false) {
        
        if isHome {
            let logoImageView = UIImageView(image: UIImage(named: "logo_icon"))
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let logoBarButton = UIBarButtonItem(customView: logoImageView)
            navigationItem.leftBarButtonItem = logoBarButton
        } else {
            let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(backButtonTapped)
            )
            backButton.tintColor = .black
            navigationItem.leftBarButtonItem = backButton
        }
        
        let bookmarkButton = UIButton()
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        
        let notificationButton = UIButton()
        notificationButton.setImage(UIImage(named: "notification"), for:  .normal)
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        
        let searchButton = UIButton()
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        let itemsStackView = UIStackView.init(arrangedSubviews: [searchButton, bookmarkButton, notificationButton])
        itemsStackView.distribution = .equalSpacing
        itemsStackView.axis = .horizontal
        itemsStackView.alignment = .center
        itemsStackView.spacing = 20
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: itemsStackView)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func searchButtonTapped() { print("검색 버튼 클릭됨") }
    @objc private func bookmarkButtonTapped() { print("북마크 버튼 클릭됨") }
    @objc private func notificationButtonTapped() { print("알림 버튼 클릭됨") }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
