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
    
    // MARK: - Init
    init(placeholder: String) {
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
}

// MARK: - UIDocumentPickerViewControllerDelegate
extension AttachmentPickerView: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        let fileName = selectedFileURL.lastPathComponent
        
        self.selectedFileURL = selectedFileURL
        fileButton.setTitle(fileName, for: .normal)
        fileButton.setTitleColor(.black, for: .normal)
        
        delegate?.didSelectFile(fileName, fileURL: selectedFileURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("파일 선택이 취소됨")
    }
}
