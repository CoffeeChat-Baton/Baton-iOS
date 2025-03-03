import UIKit

extension MentorListViewController: SegmentedControlViewDelegate {
    func segmentedControlView(_ view: SegmentedControlView, didSelectIndex index: Int) {
        pageViewController.scrollToPage(index: index)
    }
}

extension MentorListViewController: PageViewControllerDelegate {
    func pageViewController(_ pageViewController: PageViewController, didScrollToIndex index: Int) {
        segmentControl.moveIndicator(to: index)
    }
}

final class MentorListViewController: UIViewController {
    
    private let titlesStackView = UIStackView()
    private let titlesContainerView = UIView()
    private let contentContainerView = UIView()
    
    private var category: String = ""
    private lazy var titleLabel = UILabel.makeLabel(text: self.category, textColor: .bblack, fontStyle: .head1)
    private let subTitleLabel = UILabel.makeLabel(text: "멘토 리스트에 등록된 분들은 모두 2단계 인증을 통해\n재직 및 재학 정보 검증이 완료된 분들입니다.", textColor: .gray5, fontStyle: .caption2)
    private let spacer = UIView()
    // 세그먼트 컨트롤
    private var segmentControl: SegmentedControlView
    private var pageViewController: PageViewController!

    
    init(category: String, segmentTitles: [String]) {
        self.category = category
        self.segmentControl = SegmentedControlView(segmentTitles: segmentTitles) 
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBatonNavigationBar(isHome: false)
        
        setupView()
        setupConstraint()
        
//        contentContainerView.backgroundColor = .red
//        segmentControl.backgroundColor = .yellow
    }
    
    private func setupView() {
        view.backgroundColor = .gray1

        titlesStackView.translatesAutoresizingMaskIntoConstraints = false
        titlesContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        titlesContainerView.backgroundColor = .bwhite
        titlesStackView.axis = .vertical
        titlesStackView.spacing = 6
        titlesStackView.distribution = .fill
        
        view.addSubview(titlesContainerView)
        titlesContainerView.addSubview(titlesStackView)
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(subTitleLabel)
        titlesStackView.addArrangedSubview(spacer)

        segmentControl.delegate = self
        
        view.addSubview(contentContainerView)
        view.addSubview(segmentControl)
        
        let viewControllers = [
            HomeCategoryBatonsViewController(viewModel: ShowBatonsViewModel()), // 첫 번째 페이지
            UIViewController(), // 두 번째 페이지
            UIViewController()  // 세 번째 페이지
        ]
        pageViewController = PageViewController(viewControllers: viewControllers)
        pageViewController.delegate = self
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            titlesContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titlesContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titlesContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titlesContainerView.heightAnchor.constraint(equalToConstant: 112),

            titlesStackView.topAnchor.constraint(equalTo: titlesContainerView.topAnchor),
            titlesStackView.leadingAnchor.constraint(equalTo: titlesContainerView.leadingAnchor, constant: Spacing.large.value),
            titlesStackView.trailingAnchor.constraint(equalTo: titlesContainerView.trailingAnchor, constant: -Spacing.large.value),
            titlesStackView.bottomAnchor.constraint(equalTo: titlesContainerView.bottomAnchor),
            
            contentContainerView.topAnchor.constraint(equalTo: titlesContainerView.bottomAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            segmentControl.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            segmentControl.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 40),
            
            pageViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



import SwiftUI

struct MentorListViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MentorListViewController {
        return MentorListViewController(category: "iOS Mentor", segmentTitles: ["디자인", "디자인2", "디자인3"])
    }
    
    func updateUIViewController(_ uiViewController: MentorListViewController, context: Context) {}
}

struct MentorListViewController_Previews: PreviewProvider {
    static var previews: some View {
        MentorListViewControllerPreview()
            .edgesIgnoringSafeArea(.all) // 전체 화면 미리보기
    }
}
