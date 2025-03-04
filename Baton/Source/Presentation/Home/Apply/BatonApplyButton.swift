import UIKit

class BatonApplyButton: UIView {
    // ✅ 선택 상태 변경 시 appearance 업데이트
    var isSelectedState: Bool = false {
        didSet { updateAppearance() }
    }

    var onSelectionChanged: ((Bool) -> Void)? // 선택 상태 변경 시 실행될 클로저

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body1
        label.textColor = .bblack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .navibar
        label.textColor = .gray5
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.opacity = 0.5
        return imageView
    }()
    
    // MARK: - Initializer
    init(title: String, subTitle: String, imageName: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        subtitleLabel.text = subTitle
        buttonImageView.image = UIImage(named: imageName)
        
        setupView()
        setupConstraints()
        setupGesture() // ✅ 터치 이벤트 추가
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .bwhite
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray3.cgColor
        clipsToBounds = true
        
        addSubview(buttonImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            buttonImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 26),
            buttonImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40)
        ])
    }
    
    // ✅ UIView에서 버튼 동작 구현 (터치 이벤트 추가)
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func buttonTapped() {
        isSelectedState.toggle()
        onSelectionChanged?(isSelectedState) // 상태 변경 시 클로저 실행
    }

    // ✅ 버튼 선택 상태에 따른 appearance 업데이트
    private func updateAppearance() {
        backgroundColor = isSelectedState ? UIColor.blue1 : UIColor.bwhite
        layer.borderColor = isSelectedState ? UIColor.main.cgColor : UIColor.gray3.cgColor
        buttonImageView.layer.opacity = isSelectedState ? 1.0 : 0.5
    }
}

#if DEBUG
import SwiftUI

struct BatonApplyButtonRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> BatonApplyButton {
        return BatonApplyButton(title: "신청하기", subTitle: "멘토와 함께 성장하세요!", imageName: "categoryBusins")
    }

    func updateUIView(_ uiView: BatonApplyButton, context: Context) {}
}

struct BatonApplyButton_Previews: PreviewProvider {
    static var previews: some View {
        BatonApplyButtonRepresentable()
            .frame(width: 200, height: 80) // 원하는 크기로 조정 가능
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
