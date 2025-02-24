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
    
    // 🔹 하단 버튼
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.pretendardStyle = .body3
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    init(image: UIImage?, name: String, company: String, category: String, description: String, buttonTitle: String) {
        self.category = category

        super.init(frame: .zero)
        profileImageView.image = image
        nameLabel.text = name
        companyLabel.text = company
        descriptionLabel.text = description
        actionButton.setTitle(buttonTitle, for: .normal)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray2.cgColor
        
        addSubview(profileImageView)
        addSubview(textContainerView)
        addSubview(actionButton)
        addSubview(descriptionContainerView)

        // 🔹 텍스트 StackView에 요소 추가
        textContainerView.addArrangedSubview(nameLabel)
        textContainerView.addArrangedSubview(companyLabel)
        textContainerView.addArrangedSubview(descriptionContainerView)

        descriptionContainerView.addArrangedSubview(categoryTag)
        descriptionContainerView.addArrangedSubview(descriptionLabel)
        descriptionContainerView.addArrangedSubview(UIView())

                
        textContainerView.distribution = .fillEqually
        // 🔹 Auto Layout 설정
        NSLayoutConstraint.activate([
            // 프로필 이미지 위치 (왼쪽 정렬)
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // 텍스트 컨테이너 위치 (프로필 오른쪽 정렬)
            textContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            textContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textContainerView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            textContainerView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16),
            
            // 버튼 위치
            actionButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16) // 하단 여백 추가
        ])
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
            buttonTitle: "바통 입장하기"
        )
        view.layoutIfNeeded() // 미리보기에서 올바른 크기 적용
        return view
    }
    
    func updateUIView(_ uiView: BatonProfileView, context: Context) {}
}

struct BatonProfileView_Previews: PreviewProvider {
    static var previews: some View {
        BatonProfileViewRepresentable()
            .frame(width: 350, height: 168) // 적절한 크기로 조정
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
