import UIKit
import Combine

class EmployeeStatusView: BaseViewController<PartnerRegistrationViewModel> {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    private let uploadFileTitleLabel = SelectionTitleLabel(title: "첨부파일")
    private let uploadFileButton = SelectionButton(mode: .uploadFile)
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
        uploadFileButton.setTitle("파일 형식: JPG, PNG, PDF")
        
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
    private func bindViewModel() {}
    
    // MARK: - Button Actions
    @objc private func uploadFileButtonTapped() {
        showCustomModal()
    }
    
    private func showCustomModal() {
        
    }
}
