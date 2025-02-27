import UIKit

extension MentorListViewController: SegmentedPageDelegate {
    func didChangeSegment(index: Int) {
        print("현재 선택된 세그먼트: \(index)")
    }
}

class MentorListViewController: UIViewController {
    
    private let titlesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .bwhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titlesStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 6
        view.distribution = .fill
        view.alignment = .leading
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel = UILabel.makeLabel(text: "디자인", textColor: .bblack, fontStyle: .head1)
    private let subtitleLabel = UILabel.makeLabel(text: "파트너 리스트에 등록된 분들은 모두 2단계 인증을 통해 \n 재직 및 재학 정보 검증이 완료된 분들입니다.", textColor: .gray5, fontStyle: .caption2)
    
    private lazy var segmentedPageVC = SegmentedPageViewController(segmentTitles: ["프로덕트 디자인","UX/UI 디자인", "GUI 디자인", "웹 디자인"], viewControllers: self.viewControllers)

    private let viewControllers = [
                ShowBatonsViewController(viewModel: ShowBatonsViewModel()), // 대기
                ShowBatonsViewController(viewModel: ShowBatonsViewModel()), // 확정
                ShowBatonsViewController(viewModel: ShowBatonsViewModel()), // 완료
                ShowBatonsViewController(viewModel: ShowBatonsViewModel())  // 완료
            ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBatonNavigationBar(isHome: false)
        setupView()
        addSubViews()
        setupConstraint()
    }
    
    private func setupView() {
        view.backgroundColor = .gray1
        addChild(segmentedPageVC)
        segmentedPageVC.delegate = self
        segmentedPageVC.view.translatesAutoresizingMaskIntoConstraints = false
        segmentedPageVC.didMove(toParent: self)
    }
    
    private func addSubViews() {
        view.addSubview(titlesContainerView)
        titlesContainerView.addSubview(titlesStackView)
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(subtitleLabel)
        view.addSubview(segmentedPageVC.view)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titlesContainerView.heightAnchor.constraint(equalToConstant: 112),
            titlesContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titlesContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titlesContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titlesStackView.centerXAnchor.constraint(equalTo: titlesContainerView.centerXAnchor),
            titlesStackView.centerYAnchor.constraint(equalTo: titlesContainerView.centerYAnchor),
            titlesStackView.leadingAnchor.constraint(equalTo: titlesContainerView.leadingAnchor, constant: Spacing.large.value),
            titlesStackView.trailingAnchor.constraint(equalTo: titlesContainerView.trailingAnchor, constant: -Spacing.large.value),
            
            segmentedPageVC.view.topAnchor.constraint(equalTo: titlesContainerView.bottomAnchor),
            segmentedPageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedPageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedPageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
    }
}
