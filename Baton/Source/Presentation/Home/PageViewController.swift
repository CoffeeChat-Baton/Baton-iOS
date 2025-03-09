import UIKit

protocol PageViewControllerDelegate: AnyObject {
    func pageViewController(_ pageViewController: PageViewController, didScrollToIndex index: Int)
}

class PageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    weak var delegate: PageViewControllerDelegate?
    
    private let scrollView = UIScrollView()
    private let pagesStackView = UIStackView()
    private var pages: [UIViewController] = []
    
    // MARK: - Initializer
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.pages = viewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupPages()
    }
    
    // MARK: - Setup ScrollView
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        pagesStackView.axis = .horizontal
        pagesStackView.alignment = .fill
        pagesStackView.distribution = .fillEqually
        pagesStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(pagesStackView)
        
        NSLayoutConstraint.activate([
            pagesStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            pagesStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            pagesStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            pagesStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            pagesStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            pagesStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: CGFloat(pages.count))
        ])
    }
    
    // MARK: - Setup Pages
    private func setupPages() {
        for vc in pages {
            addChild(vc)
            vc.didMove(toParent: self)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            pagesStackView.addArrangedSubview(vc.view)
        }
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        delegate?.pageViewController(self, didScrollToIndex: pageIndex)
    }
    
    func scrollToPage(index: Int) {
        let offsetX = CGFloat(index) * view.frame.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
