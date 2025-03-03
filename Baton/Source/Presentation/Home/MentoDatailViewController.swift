import UIKit

extension MentoDatailViewController: BatonNavigationConfigurable {
    @objc func baseBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SegmentedControlViewDelegate
extension MentoDatailViewController: SegmentedControlViewDelegate, UIScrollViewDelegate {
    
    func segmentedControlView(_ view: SegmentedControlView, didSelectIndex index: Int) {
        let mentorInfoPosition = mentorInfoView.convert(mentorInfoView.bounds.origin, to: scrollView).y
        let reviewPosition = reviewView.convert(reviewView.bounds.origin, to: scrollView).y
        
        // 세그먼트 컨트롤의 높이 고려하여 위치 조정
        let segmentControlHeight = segmentControl.frame.height
        let targetOffset = index == 0 ? mentorInfoPosition - segmentControlHeight : reviewPosition - segmentControlHeight + 35
        
        let clampedOffset = max(targetOffset, 0)
        
        // ✅ 스크롤 이동 후 indicator 업데이트는 `scrollViewDidEndScrollingAnimation`에서 처리
        scrollView.setContentOffset(CGPoint(x: 0, y: clampedOffset), animated: true)
    }
    
    // MARK: - 스크롤 감지 → 세그먼트 컨트롤 변경
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let mentorInfoPosition = mentorInfoView.convert(mentorInfoView.bounds.origin, to: scrollView).y
        let reviewPosition = reviewView.convert(reviewView.bounds.origin, to: scrollView).y
        
        let segmentControlHeight = segmentControl.frame.height
        let currentOffset = scrollView.contentOffset.y
        
        if currentOffset >= reviewPosition - segmentControlHeight {
            segmentControl.moveIndicator(to: 1) // 후기 탭으로 변경
        } else {
            segmentControl.moveIndicator(to: 0) // 멘토 정보 탭으로 변경
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // ✅ 스크롤 이동이 끝난 후 indicator를 정확하게 이동
        let mentorInfoPosition = mentorInfoView.convert(mentorInfoView.bounds.origin, to: scrollView).y
        let reviewPosition = reviewView.convert(reviewView.bounds.origin, to: scrollView).y
        
        let segmentControlHeight = segmentControl.frame.height
        let currentOffset = scrollView.contentOffset.y

        let selectedIndex = currentOffset >= reviewPosition - segmentControlHeight ? 1 : 0
        segmentControl.moveIndicator(to: selectedIndex) // 여기서만 indicator 이동
    }
}

class MentoDatailViewController: UIViewController {
    
    // 🔹 프로필 StackView (이름, 회사, 설명 포함)
    private let profileContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 🔹 텍스트 StackView (이름, 회사, 설명 포함)
    private let textContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 🔹 세부 설명 StackView (태그, 설명)
    private let descriptionContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // 🔹 세부 설명 StackView (바통 진행, 응답률)
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 🔹 프로필 이미지
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 42 // 둥근 프로필
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .profileDefault)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 🔹 이름 Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body1
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🔹 회사 Label
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body3
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🔹 태그 뷰
    lazy private var categoryTag: BatonTag = {
        let tag = BatonTag(content: "개발", type: .category)
        return tag
    }()
    
    // 🔹 설명 Label
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body5
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0 // 여러 줄 지원
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var reviewSum: Int = 0
    private lazy var segmentControl = SegmentedControlView(segmentTitles: ["멘토 정보", "후기(\(self.reviewSum))"])
    
    private let scrollView = UIScrollView()
    private let contentView  = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let mentorInfoView = MentoInfomationView(shortInfo: "한 줄 소개 넣습니다한 줄 소개 넣습니다한 줄 소개 넣습니다한 줄 소개 넣습니다한 줄 소개 넣습니다한 줄 소개 넣습니다한 줄 소개 넣습니다한 줄 소개 넣습니다한 줄 소개 넣습니다", detailInfo: "멘토 소개 넣습니다", times: [BatonSuggestTime(days: ["화", "목"], startTime: "1:00", endIime: "2:00")])
    
    private let actionButton = BasicButton(title: "신청하기", status: .enabled)
    private let bookmarkButton = BatonBookmarkButton()

    // 멘토 정보
    private let reviewView = ReviewView(reviews: ["리뷰1", "리뷰2"])  // 후기 뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bwhite
        setupNavigationBar()
        setupView()
        setupConstraint()
        
        nameLabel.text = "박그냥"
        companyLabel.text = "네이버"
        descriptionLabel.text = "iOS 개발 | 2년차"
    }
    
    // MARK: - NavigationBar
    private func setupNavigationBar() {
        let backButton = BatonNavigationButton.backButton(target: self, action: #selector(baseBackButtonTapped))
        setupBaseNavigationBar(title: "", backButton: backButton)
    }
    
    private func setupView() {
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        segmentControl.delegate = self
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mentorInfoView.translatesAutoresizingMaskIntoConstraints = false
        reviewView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(profileContainerView)
        profileContainerView.addArrangedSubview(profileImageView)
        profileContainerView.addArrangedSubview(textContainerView)
        
        descriptionContainerView.addArrangedSubview(categoryTag)
        descriptionContainerView.addArrangedSubview(descriptionLabel)
        descriptionContainerView.addArrangedSubview(UIView())

        textContainerView.addArrangedSubview(nameLabel)
        textContainerView.addArrangedSubview(companyLabel)
        textContainerView.addArrangedSubview(descriptionContainerView)

        view.addSubview(infoContainerView)
        let spacer1 = UIView()
        let spacer4 = UIView()
        let batonLabel = makeTextView(title: "바통 진행", content: "25회")
        let reponseRateLabel = makeTextView(title: "응답률", content: "99%")
        let splitLabel = UILabel()
        splitLabel.text = "|"
        splitLabel.pretendardStyle = .body5
        splitLabel.textColor = .gray2

        infoStackView.addArrangedSubview(spacer1)
        infoStackView.addArrangedSubview(batonLabel)
        infoStackView.addArrangedSubview(splitLabel)
        infoStackView.addArrangedSubview(reponseRateLabel)
        infoStackView.addArrangedSubview(spacer4)
        infoContainerView.addSubview(infoStackView)
        view.addSubview(segmentControl)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addArrangedSubview(mentorInfoView)
        contentView.addArrangedSubview(reviewView)
        view.addSubview(actionButton)
        view.addSubview(bookmarkButton)

}
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            profileContainerView.heightAnchor.constraint(equalToConstant: 84),
            profileContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 84),
            
            infoContainerView.heightAnchor.constraint(equalToConstant: 65),
            infoContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infoContainerView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: 28),
            
            infoStackView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 9),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -12),

            segmentControl.heightAnchor.constraint(equalToConstant: 52),
            segmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            segmentControl.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: 28),
            
            // ScrollView 설정
            scrollView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // ContentView 설정
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: reviewView.bottomAnchor, constant: 20),  // ✅ 중요
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, multiplier: 1.1), // ✅ 중요
            
            bookmarkButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookmarkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 52),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 52),
            
            actionButton.leadingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: 12),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 52),
            

        ])
    }

    // ✅ 스크롤뷰 contentSize 강제 업데이트
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentView.bounds.size
    }
    
    
    private func makeTextView(title: String, content: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.pretendardStyle = .caption2
        titleLabel.textColor = .gray5
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.pretendardStyle = .body1
        contentLabel.textColor = .bblack
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)


        return stackView
    }
}

#if DEBUG
import SwiftUI

struct MentoDatailViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MentoDatailViewController {
        return MentoDatailViewController()
    }
    
    func updateUIViewController(_ uiViewController: MentoDatailViewController, context: Context) {}
}

struct MentoDatailViewController_Previews: PreviewProvider {
    static var previews: some View {
        MentoDatailViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // 전체 화면에 맞게 표시
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif

struct BatonSuggestTime {
    let days: [String]
    let startTime: String
    let endIime: String
}
// 🔹 멘토 정보 뷰 (UIView 형태로 변경)
class MentoInfomationView: UIView {
    
    private let shortInfoLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .title1
        label.textColor = .bblack
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let detailInfoTextView: BaseTextView
    private let detailInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "멘토 소개"
        label.pretendardStyle = .body1
        label.textColor = .bblack
        label.textAlignment = .left
        return label
    }()
    
    private let suggestTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "멘토가 제안하는 시간대"
        label.pretendardStyle = .body1
        label.textColor = .bblack
        label.textAlignment = .left
        return label
    }()
    
    private let timeContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private var times: [BatonSuggestTime] = []
    
    init(shortInfo: String, detailInfo: String, times: [BatonSuggestTime]) {
        self.detailInfoTextView = BaseTextView(placeholder: detailInfo, style: .filled, isEditable: false)
        super.init(frame: .zero)
        self.shortInfoLabel.text = shortInfo
        self.times = times
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.detailInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(shortInfoLabel)
        addSubview(detailInfoLabel)
        addSubview(detailInfoTextView)
        addSubview(suggestTimeLabel)
        
        for time in times {
            let content = time.days.joined(separator: ",") + " " + time.startTime + "~" + time.endIime
            let newTimeView = BaseTextView(placeholder: content, style: .filled, isEditable: false)
            timeContainerView.addArrangedSubview(newTimeView)
        }
        
        addSubview(timeContainerView)
    }
    
    private func setupConstraints() {
        shortInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        detailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        detailInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        suggestTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shortInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            shortInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            shortInfoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            detailInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailInfoLabel.topAnchor.constraint(equalTo: shortInfoLabel.bottomAnchor, constant: 32),
            
            detailInfoTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailInfoTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailInfoTextView.topAnchor.constraint(equalTo: detailInfoLabel.bottomAnchor, constant: 10),
            detailInfoTextView.heightAnchor.constraint(equalToConstant: 100),
            
            suggestTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            suggestTimeLabel.topAnchor.constraint(equalTo: detailInfoTextView.bottomAnchor, constant: 32),
            
            timeContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeContainerView.topAnchor.constraint(equalTo: suggestTimeLabel.bottomAnchor, constant: 12),
            timeContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// 🔹 간단한 후기 뷰
class ReviewView: UIView {
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "박그냥 멘토님의 후기"
        label.pretendardStyle = .title1
        label.textColor = .bblack
        label.textAlignment = .left
        return label
    }()
    
    private let starContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    private let star: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .star))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let totalScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "4.87"
        label.pretendardStyle = .body2
        label.textColor = .bblack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.text = "(10)"
        label.pretendardStyle = .body4
        label.textColor = .gray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    init(reviews: [String]) {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        setupReviews(reviews)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .gray1
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(reviewLabel)
        addSubview(starContainerView)
        starContainerView.addArrangedSubview(star)
        starContainerView.addArrangedSubview(totalScoreLabel)
        starContainerView.addArrangedSubview(sumLabel)
        starContainerView.addArrangedSubview(UIView())
        
        addSubview(reviewContainerView)
    }
    
    private func setupConstraints() {
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewContainerView.translatesAutoresizingMaskIntoConstraints = false
        starContainerView.translatesAutoresizingMaskIntoConstraints = false
        star.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reviewLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            reviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.large.value),
            reviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.large.value),
            
            starContainerView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 7),
            starContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.large.value),
            starContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.large.value),
            starContainerView.heightAnchor.constraint(equalToConstant: 24),
            
            star.widthAnchor.constraint(equalToConstant: 18),
            star.heightAnchor.constraint(equalToConstant: 18),
            
            reviewContainerView.topAnchor.constraint(equalTo: starContainerView.bottomAnchor, constant: 16),
            reviewContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.large.value),
            reviewContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.large.value),
            reviewContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupReviews(_ reviews: [String]) {
        for  _ in 0..<5 {
            let review = BatonReviewView()
            reviewContainerView.addArrangedSubview(review)
        }
    }
}
