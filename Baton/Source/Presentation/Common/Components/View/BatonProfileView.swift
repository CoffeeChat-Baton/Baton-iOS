import UIKit
import SwiftUI

class BatonProfileView: UIView {
    
    // 🔹 프로필 이미지
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40 // 둥근 프로필
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 🔹 이름 Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body3
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🔹 회사 Label
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body4
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var category: String
    lazy private var categoryTag: BatonTag = {
        let tag = BatonTag(content: category, type: .category)
        return tag
    }()
    
    // 🔹 설명 Label
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body4
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0 // 여러 줄 지원
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shortIntroLabel = UILabel.makeLabel(text: "", textColor: .bblack, fontStyle: .body3)
    
    // 🔹 하단 버튼
    private let actionButton: BasicButton
    
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let basicContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
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
    
    private let descriptionContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let batonInfoContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 12
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.gray2.cgColor
        stackView.distribution = .equalCentering
        stackView.spacing = 8 // ✅ 간격 추가
        stackView.alignment = .center
        return stackView
    }()
    
    init(image: UIImage?, name: String, company: String, category: String, description: String, buttonTitle: String?, status: Bool = true, shortIntro: String? = nil) {
        self.category = category
        
        // ✅ 버튼이 존재할 경우에만 생성
        if let title = buttonTitle {
            self.actionButton = BasicButton(title: title, status: status ? .enabled : .disabled)
        } else {
            self.actionButton = BasicButton(title: "", status: .disabled)
            self.actionButton.isHidden = true
        }
        
        // 한 줄 소개 등록 시
        if let shortIntro = shortIntro {
            shortIntroLabel.text = shortIntro
        } else {
            shortIntroLabel.isHidden = true
        }

        super.init(frame: .zero)
        
        profileImageView.image = image
        nameLabel.text = name
        companyLabel.text = company
        descriptionLabel.text = description
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeTextView(title: String, content: String) -> UIView {
        let titleLabel = UILabel.makeLabel(text: title, textColor: .gray5, fontStyle: .caption2)
        let contentLabel = UILabel.makeLabel(text: content, textColor: .bblack, fontStyle: .caption1)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)

        return stackView
    }
    
    private func setupView() {
        backgroundColor = UIColor(resource: .bwhite)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray2.cgColor
        shortIntroLabel.translatesAutoresizingMaskIntoConstraints = false
        shortIntroLabel.backgroundColor = .red
        addSubview(containerView)
        containerView.addArrangedSubview(basicContainerView)
        containerView.addArrangedSubview(shortIntroLabel)
        //containerView.addArrangedSubview(actionButton)
        containerView.addArrangedSubview(batonInfoContainerView)
        
        basicContainerView.addArrangedSubview(profileImageView)
        basicContainerView.addArrangedSubview(textContainerView)
        
        textContainerView.addArrangedSubview(nameLabel)
        textContainerView.addArrangedSubview(companyLabel)
        textContainerView.addArrangedSubview(descriptionContainerView)
        
        descriptionContainerView.addArrangedSubview(categoryTag)
        descriptionContainerView.addArrangedSubview(descriptionLabel)
        descriptionContainerView.addArrangedSubview(UIView())
        let spacer1 = UIView()
        let spacer2 = UIView()
        let spacer3 = UIView()
        let spacer4 = UIView()
        let splitLabel = UILabel.makeLabel(text: "|", textColor: .gray2, fontStyle: .body5)
        let batonLabel = makeTextView(title: "바통", content: "5회")
        let reponseRateLabel = makeTextView(title: "응답률", content: "88%")

        batonInfoContainerView.addArrangedSubview(spacer1)
        batonInfoContainerView.addArrangedSubview(batonLabel)
//        batonInfoContainerView.addArrangedSubview(spacer2)
        batonInfoContainerView.addArrangedSubview(splitLabel)

//        batonInfoContainerView.addArrangedSubview(spacer3)
        batonInfoContainerView.addArrangedSubview(reponseRateLabel)
        batonInfoContainerView.addArrangedSubview(spacer4)

        
        textContainerView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            textContainerView.heightAnchor.constraint(equalToConstant: 78),
            
            shortIntroLabel.heightAnchor.constraint(equalToConstant: 23),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            batonInfoContainerView.heightAnchor.constraint(equalToConstant: 31)
            
        ])
    }
    
    private func setupActiveButton() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded() // 🔹 Auto Layout 강제 적용
    }
}

#if DEBUG
struct BatonProfileViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> BatonProfileView {
        let view = BatonProfileView(
            image: UIImage(resource: .profileDefault),
            name: "박그냥",
            company: "네이버", category: "개발",
            description: "iOS 개발 | 4년차",
            buttonTitle: "바통 입장하기",
            shortIntro: "나를 돋보일 수 있는 포트폴리오 전략"
        )
        view.layoutIfNeeded() // 미리보기에서 올바른 크기 적용
        return view
    }
    
    func updateUIView(_ uiView: BatonProfileView, context: Context) {}
}

struct BatonProfileView_Previews: PreviewProvider {
    static var previews: some View {
        BatonProfileViewRepresentable()
            .frame(width: 350, height: 184) // 적절한 크기로 조정
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
