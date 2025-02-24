import UIKit

class ShowBatonsViewController: UIViewController {
    
    private let titleContainerView = UIStackView()
    
    // 🔹 필터 버튼 (화면 최상단 오른쪽)
    private let filterButton: BatonFilterButton = {
        let button = BatonFilterButton(title: "필터 선택", options: ["전체", "개발", "디자인", "마케팅"])
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 🔹 스크롤뷰와 내부 StackView
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // 🔹 태그(타임 타입) – BatonTag의 타입이 .time 인 경우
    private let tagView: BatonTag = {
        let tag = BatonTag(content: "20", type: .time)
        tag.translatesAutoresizingMaskIntoConstraints = false
        return tag
    }()
    
    // 🔹 텍스트 레이블 (설명)
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "이곳은 상세 설명을 넣는 레이블입니다."
        label.pretendardStyle = .body4
        label.textColor = .bblack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🔹 프로필 뷰 (BatonProfileView)
    private let profileView: BatonProfileView = {
        let profile = BatonProfileView(
            image: UIImage(resource: .profileDefault),
            name: "홍길동",
            company: "Example Inc.",
            category: "개발",
            description: "iOS Developer",
            buttonTitle: "메시지 보내기"
        )
        profile.translatesAutoresizingMaskIntoConstraints = false
        return profile
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupFilterButton()
        setupScrollView()
        setupContentStackView()
    }
    
    private func setupFilterButton() {
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 5),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupContentStackView() {
        titleContainerView.axis = .horizontal
        titleContainerView.spacing = 8
        titleContainerView.alignment = .center
        titleContainerView.distribution = .fill
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.addArrangedSubview(tagView)
        titleContainerView.addArrangedSubview(infoLabel)
        titleContainerView.addArrangedSubview(UIView())

        contentStackView.addArrangedSubview(titleContainerView)
        contentStackView.addArrangedSubview(profileView)

        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            
            profileView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: 16),
            profileView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -16) // ✅ 프로필 뷰가 꽉 차도록 설정
        ])
    }
}

#if DEBUG
import SwiftUI

struct ShowBatonsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ShowBatonsViewController {
        return ShowBatonsViewController()
    }
    
    func updateUIViewController(_ uiViewController: ShowBatonsViewController, context: Context) {}
}

struct ShowBatonsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ShowBatonsViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // 전체 화면에 맞게 표시
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
