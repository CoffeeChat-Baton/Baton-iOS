import UIKit

final class BatonBookmarkButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 버튼 UI 초기 설정
    private func configureButton() {
        let image = UIImage(resource: .bookmarkFill)
        setImage(image, for: .normal) // ✅ 이미지 추가
        imageView?.contentMode = .scaleAspectFit
        layer.cornerRadius = 12
        backgroundColor = .bwhite
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray3.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        // ✅ 이미지 크기 조정 (imageView 기준으로 설정)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView!.widthAnchor.constraint(equalToConstant: 24), // 이미지 크기
            imageView!.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
