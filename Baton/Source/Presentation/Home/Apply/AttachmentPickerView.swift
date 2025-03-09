import UIKit
import UniformTypeIdentifiers

// MARK: - Delegate Protocol (파일 선택 결과 전달)
protocol AttachmentPickerDelegate: AnyObject {
    func didSelectFile(_ fileName: String, fileURL: URL)
}

class AttachmentPickerView: UIView {
    
    // MARK: - Properties
    weak var delegate: AttachmentPickerDelegate? // 파일 선택 결과 전달
    private let fileButton: UIButton
    private var selectedFileURL: URL?
    var content: Data?
    
    // MARK: - Init
    init(placeholder: String, isEditable: Bool = true) {
        self.fileButton = UIButton(type: .system)
        super.init(frame: .zero)

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .gray1
        config.baseForegroundColor = .gray4
        config.image = UIImage(resource: .uploadFile).withRenderingMode(.alwaysTemplate)
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        let title = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.Pretendard.body5.font,
                .foregroundColor: UIColor.gray4
            ]
        )
        config.attributedTitle = AttributedString(title)
        
        fileButton.configuration = config
        fileButton.contentHorizontalAlignment = .leading

        fileButton.addTarget(self, action: #selector(uploadFileButtonTapped), for: .touchUpInside)
        
        setupLayout()
        self.isUserInteractionEnabled = isEditable
        
        if !isEditable {
            updateStyle(title: placeholder)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout 설정
    private func setupLayout() {
        addSubview(fileButton)
        
        fileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fileButton.topAnchor.constraint(equalTo: topAnchor),
            fileButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            fileButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            fileButton.heightAnchor.constraint(equalToConstant: 48),
            fileButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - 파일 선택 버튼 클릭 시
    @objc private func uploadFileButtonTapped() {
        showDocumentPicker()
    }
    
    // MARK: - Document Picker 표시
    private func showDocumentPicker() {
        let supportedTypes: [UTType] = [.pdf, .png, .jpeg]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true)
    }
    
    private func updateStyle(title: String) {
        fileButton.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            
            // 기존의 attributedTitle을 가져와서 텍스트 색상을 변경
            let title = button.title(for: .normal) ?? "파일 업로드"
            let updatedTitle = NSAttributedString(
                string: title,
                attributes: [
                    .font: UIFont.Pretendard.body5.font,
                    .foregroundColor: UIColor.bblack
                ]
            )
            updatedConfig?.baseForegroundColor = .bblack 
            updatedConfig?.attributedTitle = AttributedString(updatedTitle)
            button.configuration = updatedConfig
        }
        fileButton.setNeedsUpdateConfiguration()
    }
}

// MARK: - UIDocumentPickerViewControllerDelegate
extension AttachmentPickerView: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        let fileName = selectedFileURL.lastPathComponent
        
        self.selectedFileURL = selectedFileURL
        updateStyle(title: fileName)

        delegate?.didSelectFile(fileName, fileURL: selectedFileURL)
        
        if let fileData = try? Data(contentsOf: selectedFileURL) {
            content = fileData
            print("파일 크기: \(fileData.count) 바이트")
        }

    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("파일 선택이 취소됨")
    }
}

#if DEBUG
import SwiftUI

struct AttachmentPickerViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> AttachmentPickerView {
        let attachmentPicker = AttachmentPickerView(placeholder: "파일을 업로드해주세요", isEditable: false)
        return attachmentPicker
    }
    
    func updateUIView(_ uiView: AttachmentPickerView, context: Context) {}
}

struct AttachmentPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentPickerViewRepresentable()
            .frame(height: 48)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
