import UIKit
import SwiftUI

/// 동그란 버튼 + 가운데 UIImageView(Aspect Fill)로 프로필 이미지 표시
class RoundProfileButton: UIControl, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 내부에 이미지를 표시할 뷰
    private let imageView = UIImageView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        clipsToBounds = true
        backgroundColor = .systemGray5
        
        // imageView 설정 (Aspect Fill)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .profileDefault)
        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 둥근 모양
        layer.cornerRadius = min(bounds.width, bounds.height) / 2

        // imageView 전체 채움
        imageView.frame = bounds
    }

    // MARK: - Tap Action
    @objc private func buttonTapped() {
        presentImagePicker()
    }

    // MARK: - ImagePicker
    private func presentImagePicker() {
        guard let topVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController
        else {
            return
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        topVC.present(picker, animated: true)
    }

    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let selectedImage = info[.originalImage] as? UIImage {
            // imageView에 이미지를 할당 => Aspect Fill로 표시
            imageView.image = selectedImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
struct RoundProfileButtonRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> RoundProfileButton {
        RoundProfileButton()
    }
    
    func updateUIView(_ uiView: RoundProfileButton, context: Context) {}
}

#if DEBUG
struct RoundProfileButtonRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RoundProfileButtonRepresentable()
                .frame(width: 100, height: 100)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Small")
            
            RoundProfileButtonRepresentable()
                .frame(width: 140, height: 140)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Large")
        }
    }
}
#endif
