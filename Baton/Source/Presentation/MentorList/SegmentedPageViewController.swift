import UIKit

protocol SegmentedPageDelegate: AnyObject {
    func didChangeSegment(index: Int)
}

class SegmentedPageViewController: UIViewController, UIScrollViewDelegate {
    
    private let segmentTitles: [String]
    private var segmentButtons: [UIButton] = []
    private let segmentedControl = UIView()
    private let indicatorView = UIView()
    private let scrollView = UIScrollView()
    
    weak var delegate: SegmentedPageDelegate?
    
    init(segmentTitles: [String], viewControllers: [UIViewController]) {
        self.segmentTitles = segmentTitles
        super.init(nibName: nil, bundle: nil)
        setupSegmentedControl()
        setupScrollView(viewControllers: viewControllers)
        updateSegmentButtonColors(currentIndex: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .bwhite
        view.addSubview(segmentedControl)

        let buttonWidth = view.frame.width / CGFloat(segmentTitles.count)
        for (index, title) in segmentTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.pretendardStyle = .body3
            button.tintColor = .bblack
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: 65)
            button.tag = index
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
            segmentedControl.addSubview(button)
            segmentButtons.append(button)
        }

        // 하단 회색 줄
        let bottomLine = UIView()
        bottomLine.backgroundColor = .gray2
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addSubview(bottomLine)

        // Indicator View
        indicatorView.backgroundColor = .bblack
        indicatorView.frame = CGRect(x: 0, y: 63, width: buttonWidth, height: 2)
        segmentedControl.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 65),

            bottomLine.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
    
    private func setupScrollView(viewControllers: [UIViewController]) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        for (index, vc) in viewControllers.enumerated() {
            addChild(vc)
            let pageFrame = CGRect(
                x: CGFloat(index) * view.frame.width,
                y: 0,
                width: view.frame.width,
                height: scrollView.frame.height
            )
            vc.view.frame = pageFrame
            scrollView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(viewControllers.count), height: scrollView.frame.height)
    }

    @objc private func segmentButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let offset = CGPoint(x: CGFloat(index) * view.frame.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        updateSegmentButtonColors(currentIndex: index)
        delegate?.didChangeSegment(index: index)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        updateSegmentButtonColors(currentIndex: pageIndex)
        delegate?.didChangeSegment(index: pageIndex)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / view.frame.width
        let buttonWidth = segmentedControl.frame.width / CGFloat(segmentTitles.count)
        indicatorView.frame.origin.x = progress * buttonWidth
    }

    private func updateSegmentButtonColors(currentIndex: Int) {
        for (index, button) in segmentButtons.enumerated() {
            button.setTitleColor(index == currentIndex ? .black : .gray, for: .normal)
        }
    }
}
