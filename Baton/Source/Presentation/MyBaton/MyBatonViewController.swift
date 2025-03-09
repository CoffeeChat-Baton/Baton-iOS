import UIKit

class MyBatonViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    let segmentedControl = UIView()
    let indicatorView = UIView()
    let segmentTitles = ["대기", "확정", "완료"]
    var segmentButtons = [UIButton]()
    let scrollView = UIScrollView()
    let pagesStackView = UIStackView()  // 스크롤뷰 내부에 추가할 스택뷰
    
    // indicator의 leading 제약을 업데이트하기 위한 변수
    private var indicatorLeadingConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBatonNavigationBar() // 기존 네비게이션 바 설정 함수 (필요에 따라)
        view.backgroundColor = .bwhite
        setupSegmentedControl()
        setupScrollView()
        updateSegmentButtonColors(currentIndex: 0)
    }
    
    // MARK: - Setup Segmented Control
    func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .bwhite
        view.addSubview(segmentedControl)
        
        // segmentedControl를 안전 영역 상단에 고정 (네비게이션 바 바로 아래)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        // 세그먼트 버튼들을 담을 수평 UIStackView 생성
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: segmentedControl.topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor)
        ])
        
        // 각 세그먼트 버튼 생성 및 stackView에 추가
        for (index, title) in segmentTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.pretendardStyle = .body3
            button.tintColor = .bblack
            button.tag = index
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.addArrangedSubview(button)
            segmentButtons.append(button)
        }
        
        // 회색 줄 추가 (전체 너비)
        let bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = .gray2
        segmentedControl.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 2),
            bottomLine.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor)
        ])
        
        // indicator 뷰 설정 (버튼 하단에 위치)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.backgroundColor = .bblack
        segmentedControl.addSubview(indicatorView)
        
        // indicator의 너비 = segmentedControl 너비 / 세그먼트 개수
        let indicatorWidth = view.frame.width / CGFloat(segmentTitles.count)
        indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
        indicatorLeadingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: indicatorWidth)
        ])
    }
    
    // MARK: - Setup ScrollView & Pages
    func setupScrollView() {
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
        
        // 스크롤뷰 내부에 페이지들을 담을 수평 UIStackView 설정
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
            // **추가 constraint**: 전체 페이지의 너비를 스크롤뷰의 너비의 세그먼트 개수로 고정
            pagesStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: CGFloat(segmentTitles.count))
        ])
        
        // 각 페이지(자식 뷰컨트롤러의 뷰) 추가
        for _ in 0..<segmentTitles.count {
            let viewModel = ShowBatonsViewModel()
            let exampleVC = ShowBatonsViewController(viewModel: viewModel)
            addChild(exampleVC)
            exampleVC.didMove(toParent: self)
            exampleVC.view.translatesAutoresizingMaskIntoConstraints = false
            pagesStackView.addArrangedSubview(exampleVC.view)
        }
    }
    
    // MARK: - Button Actions
    @objc func segmentButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let offsetX = CGFloat(index) * view.frame.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        updateSegmentButtonColors(currentIndex: index)
    }
    
    // 스크롤뷰가 멈췄을 때 현재 페이지 인덱스 계산
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        updateSegmentButtonColors(currentIndex: pageIndex)
    }
    
    // 스크롤 시 indicator 위치 업데이트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = view.frame.width
        let progress = scrollView.contentOffset.x / pageWidth
        let buttonWidth = segmentedControl.frame.width / CGFloat(segmentTitles.count)
        indicatorLeadingConstraint?.constant = progress * buttonWidth
    }
    
    func updateSegmentButtonColors(currentIndex: Int) {
        for (index, button) in segmentButtons.enumerated() {
            button.setTitleColor(index == currentIndex ? .black : .gray, for: .normal)
        }
    }
}
