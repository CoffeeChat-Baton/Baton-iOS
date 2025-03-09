import UIKit
import SwiftUI

class TextInputAlertModalViewController: BaseAlertModalViewController {
    
    private let textField: BaseTextView  = BaseTextView(placeholder: "취소 사유를 작성해주세요", maxLength: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    private func setupTextField() {
        addContentView(textField)
    }
    
    override func actionButtonTapped() {
        super.actionButtonTapped()
    }
}

// ✅ 텍스트 입력 가능한 알림 모달 미리보기
struct TextInputAlertModalPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TextInputAlertModalViewController {
        let modal = TextInputAlertModalViewController(
            title: "바통을 취소하시겠어요?",
            subtitle: "한 번 확정된 바통을 취소하면 되돌릴 수 없습니다.\n취소 사유를 작성해주세요.",
            actionTitle: "확인",
            actionHandler: {
                print("✅ 입력된 값 확인")
            }
        )
        return modal
    }
    
    func updateUIViewController(_ uiViewController: TextInputAlertModalViewController, context: Context) {}
}

struct TextAlertModal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            TextInputAlertModalPreview()
                .edgesIgnoringSafeArea(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}
