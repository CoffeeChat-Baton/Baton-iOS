import UIKit


// 🔹 데이터소스 및 델리게이트 구현
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundImageButtonWithLabelCell.identifier, for: indexPath) as! RoundImageButtonWithLabelCell
        cell.configure(with: buttonImages[indexPath.item], title: categories[indexPath.item])
        return cell
    }
    
    // 🔹 4x5 배치를 위한 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing
        let width = (collectionView.frame.width - totalSpacing - 20) / itemsPerRow
        return CGSize(width: width, height: width) // 정사각형 버튼
    }
}

final class HomeViewController: UIViewController {
    
    private let buttonImages: [UIImage?] = [
        UIImage(resource: .categoryBusins),
        UIImage(resource: .categoryService),
        UIImage(resource: .categoryDev),
        UIImage(resource: .categoryData),
        UIImage(resource: .categoryMarketing),
        UIImage(resource: .categoryDesign),
        UIImage(resource: .categoryMedia),
        UIImage(resource: .categoryEcommerce),
        UIImage(resource: .categoryFinance),
        UIImage(resource: .categoryAccounting),
        UIImage(resource: .categoryHrCustomersale),
        UIImage(resource: .categoryHrCustomersale),
        UIImage(resource: .categoryGame),
        UIImage(resource: .categoryMarketing),
        UIImage(resource: .categoryMedical),
        UIImage(resource: .categoryResearch),
        UIImage(resource: .categoryEngineering),
        UIImage(resource: .categoryProduction),
        UIImage(resource: .categoryEducation),
        UIImage(resource: .categoryLaw),
        UIImage(resource: .categoryPublic)
    ]
    
    let categories: [String] = [
        "경영",
        "서비스기획",
        "개발",
        "데이터·AI·ML",
        "마케팅",
        "디자인",
        "미디어",
        "이커머스",
        "금융",
        "회계",
        "인사",
        "고객·영업",
        "게임",
        "물류",
        "의료",
        "연구",
        "엔지니어링",
        "생산",
        "교육",
        "법률·특허",
        "공공",
        "닫기"
    ]
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

        setupBatonNavigationBar()
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
        collectionView.backgroundColor = .red

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
}


class AdBannerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let banners: [UIImage] = [
        UIImage(resource: .homeBanner1) ?? UIImage(systemName: "photo")!,
        UIImage(resource: .homeBanner2) ?? UIImage(systemName: "photo")!,
    ]
    
    private var timer: Timer?
    private var currentIndex = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
        startAutoScroll()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextBanner), userInfo: nil, repeats: true)
    }

    @objc private func nextBanner() {
        currentIndex = (currentIndex + 1) % banners.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / frame.width)
        startAutoScroll()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell
        cell.configure(with: banners[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}

class BannerCollectionViewCell: UICollectionViewCell {
    static let identifier = "BannerCollectionViewCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill // ✅ 변경
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage) {
        imageView.image = image
    }
}
