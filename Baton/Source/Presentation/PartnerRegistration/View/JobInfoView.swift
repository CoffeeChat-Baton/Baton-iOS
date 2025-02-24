import UIKit
import Combine

extension JobInfoView: SelectionModalDelegate {
    func didSelectOption(_ option: String, type: PartnerRegistrationViewModel.SelectionType) {
        viewModel.updateSelection(for: type, with: option)
    }
}

class JobInfoView: BaseViewController<PartnerRegistrationViewModel> {
    
    private let jobTitleLabel = SelectionTitleLabel(title: "직무")
    private let jobButton = SelectionButton(placeholder: "직무 선택")
    
    private let subJobTitleLabel = SelectionTitleLabel(title: "세부 직무")
    private let subJobButton = SelectionButton(placeholder: "세부 직무 선택")
    
    private let companyTitleLabel = SelectionTitleLabel(title: "회사")
    private let companyTextField = BasicTextField(placeholder: "회사명을 입력해주세요.")
    
    private let experienceTitleLabel = SelectionTitleLabel(title: "총 경력")
    private let experienceButton = SelectionButton(placeholder: "경력 선택")
    
    private var cancellables = Set<AnyCancellable>() // ✅ Combine 구독
    
    var onContentStateChanged: ((Bool) -> Void)?
    
    init(viewModel: PartnerRegistrationViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: {viewModel.goToNextStep()})
        setupView()
        setupStackView()
        bindViewModel()
        view.addTapToDismissKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        jobButton.addTarget(self, action: #selector(jobButtonTapped), for: .touchUpInside)
        subJobButton.addTarget(self, action: #selector(subJobButtonTapped), for: .touchUpInside)
        experienceButton.addTarget(self, action: #selector(experienceButtonTapped), for: .touchUpInside)
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            SubStackView(label: jobTitleLabel, view: jobButton),
            SubStackView(label: subJobTitleLabel, view: subJobButton),
            SubStackView(label: companyTitleLabel, view: companyTextField),
            SubStackView(label: experienceTitleLabel, view: experienceButton),
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jobButton.heightAnchor.constraint(equalToConstant: 48),
            subJobButton.heightAnchor.constraint(equalToConstant: 48),
            companyTextField.heightAnchor.constraint(equalToConstant: 48),
            experienceButton.heightAnchor.constraint(equalToConstant: 48),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    private func bindViewModel(){
        viewModel.$selectedJob
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.jobButton.updateTitle(newValue)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedSubJob
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.subJobButton.updateTitle(newValue)
            }
            .store(in: &cancellables)
        
        companyTextField.onTextChanged = { [weak self] text in
            self?.viewModel.companyName = text
        }
        
        viewModel.$selectedExperience
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.experienceButton.updateTitle(newValue)
            }
            .store(in: &cancellables)
    }
    
    @objc private func jobButtonTapped() {
        showCustomModal(selectionType: .job)
    }
    
    @objc private func subJobButtonTapped() {
        showCustomModal(selectionType: .subJob)
    }
    
    @objc private func experienceButtonTapped() {
        showCustomModal(selectionType: .experience)
    }
    
    private func showCustomModal(selectionType: PartnerRegistrationViewModel.SelectionType) {
        guard let parentVC = view.findViewController() else { return }
        
        let headerTitle = viewModel.getTitle(for: selectionType)
        let options = viewModel.getOptions(for: selectionType)
        let selectedOption = viewModel.getSelection(for: selectionType)
        let modal = SelectionModal(headerTitle: headerTitle, options: options, selectionType: selectionType, delegate: self, selectedOption: selectedOption)
        
        parentVC.present(modal, animated: true)
    }
}

