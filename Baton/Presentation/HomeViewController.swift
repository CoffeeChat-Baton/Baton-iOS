import UIKit

final class HomeViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        return searchBar
    }()
    
    private let centerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중앙 버튼", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 네비게이션 바에 검색창 추가
        navigationItem.titleView = searchBar
        
        // 중앙 버튼 추가
        view.addSubview(centerButton)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func centerButtonTapped() {
        print("중앙 버튼이 눌렸습니다.")
    }
}
