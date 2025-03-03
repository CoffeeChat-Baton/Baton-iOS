import UIKit


// 데이터소스 및 델리게이트 구현
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundImageButtonWithLabelCell.identifier, for: indexPath) as! RoundImageButtonWithLabelCell
        let currCategory = viewModel.categories[indexPath.item]
        cell.configure(with: currCategory.image, title: currCategory.name)
        return cell
    }
    
    // 4x5 배치를 위한 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing
        let width = (collectionView.frame.width - totalSpacing - 20) / itemsPerRow
        return CGSize(width: width, height: width) // 정사각형 버튼
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories[indexPath.item] // 선택된 카테고리
        navigateToCategoryScreen(category: selectedCategory.name)
    }
}

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let spacer = UIView()

    // 🔹 광고 배너
    private let adBannerView: AdBannerView = {
        let view = AdBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let myBatonsTitleLabel = UILabel.makeLabel(text: "다가오는 나의 바통은?", textColor: .bblack, fontStyle: .title1)

    private let categoryTitleLabel = UILabel.makeLabel(text: "멘토 둘러보기", textColor: .bblack, fontStyle: .title1)
    
    // 🔹 카테고리 리스트
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10 // 버튼 간 간격
        layout.minimumLineSpacing = 10 // 줄 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray1

        setupBatonNavigationBar(isHome: true)
        setupScrollView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RoundImageButtonWithLabelCell.self, forCellWithReuseIdentifier: RoundImageButtonWithLabelCell.identifier)
    
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(spacer)
        contentStackView.addArrangedSubview(adBannerView)
        contentStackView.addArrangedSubview(myBatonsTitleLabel)
        contentStackView.addArrangedSubview(categoryTitleLabel)
        contentStackView.addArrangedSubview(collectionView)

        NSLayoutConstraint.activate([
            // 🔹 scrollView 설정
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // 🔹 contentStackView 설정
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // 🔹 광고 배너 설정
            adBannerView.heightAnchor.constraint(equalToConstant: 166),

            // 🔹 컬렉션 뷰 높이 설정 (동적으로 계산)
            collectionView.heightAnchor.constraint(equalToConstant: 600) // ⬅ 필요에 따라 동적 설정 가능
        ])
    }
    
    private func navigateToCategoryScreen(category: String) {
        // TODO: 세그멘탈 타이틀 처리하기
        let mentorListVC = MentorListViewController(category: category, segmentTitles: ["디자인", "디자인2"])
        navigationController?.pushViewController(mentorListVC, animated: true)
    }}
