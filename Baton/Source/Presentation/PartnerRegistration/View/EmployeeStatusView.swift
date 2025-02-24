import UIKit
import UniformTypeIdentifiers
import Combine

class EmployeeStatusView: BaseViewController<PartnerRegistrationViewModel> {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    private let uploadFileTitleLabel = SelectionTitleLabel(title: "첨부파일", style: .body4 , color: .bblack )
    private let uploadFileButton = SelectionButton(mode: .uploadFile, placeholder: "파일 형식: JPG, PNG, PDF")
    private var stackView = UIStackView()
    
    // MARK: - Init
    init(viewModel: PartnerRegistrationViewModel) {
        super.init(viewModel: viewModel, onNext: {viewModel.goToNextStep()})
        setupView()
        setupLayout()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupView() {
        uploadFileButton.addTarget(self, action: #selector(uploadFileButtonTapped), for: .touchUpInside)
        
        stackView = SubStackView(label: uploadFileTitleLabel, view: uploadFileButton)
    }
    
    private func setupLayout() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            uploadFileButton.heightAnchor.constraint(equalToConstant: 48),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Load Options
    private func bindViewModel() {
        viewModel.$selectedFileName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fileName in
                self?.uploadFileButton.updateTitle(fileName.isEmpty ? "파일 형식: JPG, PNG, PDF" : fileName)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Button Actions
    @objc private func uploadFileButtonTapped() {
        showDocumentPicker()
    }
    
    private func showDocumentPicker() {
        let supportedTypes: [UTType] = [
            .pdf,
            .png,
            .jpeg
        ]
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
}

// MARK: - UIDocumentPicker Delegate
extension EmployeeStatusView: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        let fileName = selectedFileURL.lastPathComponent
                
        viewModel.selectedFileName = fileName
        viewModel.selectedFileURL = selectedFileURL
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("파일 선택이 취소됨")
    }
}
