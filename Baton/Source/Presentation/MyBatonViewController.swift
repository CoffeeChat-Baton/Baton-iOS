import UIKit

class MyBatonViewController: UIViewController, UIScrollViewDelegate {
    let segmentedControl = UIView()
    let indicatorView = UIView()
    let segmentTitles = ["대기", "확정", "완료"]
    var segmentButtons = [UIButton]()
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBatonNavigationBar()
        view.backgroundColor = .bwhite
        setupSegmentedControl()
        setupScrollView()
        updateSegmentButtonColors(currentIndex: 0)
    }
    
    func setupSegmentedControl() {
        // 네비게이션 바 바로 아래에 배치 (원하는 위치에 맞춰 조정)
        let topY = (navigationController?.navigationBar.frame.maxY ?? 0)
        segmentedControl.frame = CGRect(x: 0, y: topY, width: view.frame.width, height: 65)
        segmentedControl.backgroundColor = .bwhite
        view.addSubview(segmentedControl)
        
        // 각 세그먼트 버튼 생성
        let buttonWidth = segmentedControl.frame.width / CGFloat(segmentTitles.count)
        for (index, title) in segmentTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.pretendardStyle = .body3
            button.tintColor = .bblack
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: segmentedControl.frame.height)
            button.tag = index
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
            segmentedControl.addSubview(button)
            segmentButtons.append(button)
        }
        
        // 회색 줄 추가 (전체 너비를 차지)
        let lineHeight: CGFloat = 2.0
        let bottomLine = UIView(frame: CGRect(x: 0, y: segmentedControl.frame.height - lineHeight, width: segmentedControl.frame.width, height: lineHeight))
        bottomLine.backgroundColor = .gray2
        segmentedControl.addSubview(bottomLine)
        
        // indicator 바 설정 (버튼 하단에 위치)
        let indicatorHeight: CGFloat = 2
        indicatorView.frame = CGRect(x: 0, y: segmentedControl.frame.height - indicatorHeight, width: buttonWidth, height: indicatorHeight)
        indicatorView.backgroundColor = .bblack  // 원하는 색상 선택
        
        segmentedControl.addSubview(indicatorView)
    }
    
    func setupScrollView() {
        // segmentedControl 바로 아래에 scrollView 배치
        let yOrigin = segmentedControl.frame.maxY
        scrollView.frame = CGRect(x: 0, y: yOrigin, width: view.frame.width, height: view.frame.height - yOrigin)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(segmentTitles.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // 각 페이지(대기, 확정, 완료) 뷰 추가
        for i in 0..<segmentTitles.count {
            let pageFrame = CGRect(x: CGFloat(i) * view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height)
            let pageView = UIView(frame: pageFrame)
            
            // 배경색은 페이지 식별을 위한 예시로 설정 (원하는 대로 커스터마이징)
            pageView.backgroundColor = [UIColor.systemGray6, UIColor.systemGray4, UIColor.systemGray2][i]
            
            // 중앙에 라벨 추가 (예시)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
            label.center = CGPoint(x: view.frame.width / 2, y: pageView.frame.height / 2)
            label.textAlignment = .center
            label.text = segmentTitles[i]
            pageView.addSubview(label)
            
            scrollView.addSubview(pageView)
        }
    }
    
    @objc func segmentButtonTapped(_ sender: UIButton) {
        // 탭한 버튼에 해당하는 페이지로 이동
        let index = sender.tag
        let offset = CGPoint(x: CGFloat(index) * view.frame.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        updateSegmentButtonColors(currentIndex: index)
    }
    
    // 스크롤뷰가 멈췄을 때 현재 페이지 인덱스 계산
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        updateSegmentButtonColors(currentIndex: pageIndex)
    }
    
    // indicator 위치 업데이트 (스와이프 진행 시)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = view.frame.width
        let progress = scrollView.contentOffset.x / pageWidth
        let buttonWidth = segmentedControl.frame.width / CGFloat(segmentTitles.count)
        indicatorView.frame.origin.x = progress * buttonWidth
    }
    
    
    func updateSegmentButtonColors(currentIndex: Int) {
        for (index, button) in segmentButtons.enumerated() {
            if index == currentIndex {
                button.setTitleColor(.black, for: .normal)
            } else {
                button.setTitleColor(.gray, for: .normal)
            }
        }
    }
}

