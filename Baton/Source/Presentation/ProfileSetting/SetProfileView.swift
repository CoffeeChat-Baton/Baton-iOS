import UIKit
import Combine

extension SetProfileView: SelectionModalDelegate {
    func didSelectOption(_ option: String, type: ProfileSettingViewModel.SelectionType) {
        viewModel.updateSelection(for: type, with: option)
    }
}

class SetProfileView: BaseViewController<ProfileSettingViewModel> {
    
    private let jobTitleLabel = SelectionTitleLabel(title: "직무", style: .body4 , color: .gray5 )
    private let subJobTitleLabel = SelectionTitleLabel(title: "세부 직무", style: .body4 , color: .gray5 )
    private let experienceTitleLabel = SelectionTitleLabel(title: "총 경력", style: .body4 , color: .gray5 )

    private let jobButton = SelectionButton(placeholder: "직무 선택")
    private let subJobButton = SelectionButton(placeholder: "세부 직무 선택")
    private let experienceButton = SelectionButton(placeholder: "경력 선택")
    
    private var cancellables = Set<AnyCancellable>() // ✅ Combine 구독
    
    var onContentStateChanged: ((Bool) -> Void)?
    
    init(viewModel: ProfileSettingViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: {viewModel.goToNextStep()})
        setupView()
        setupStackView()
        bindViewModel()
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
            SubStackView(label: jobTitleLabel, button: jobButton),
            SubStackView(label: subJobTitleLabel, button: subJobButton),
            SubStackView(label: experienceTitleLabel, button: experienceButton),
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
            experienceButton.heightAnchor.constraint(equalToConstant: 48),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    private func bindViewModel(){
        viewModel.$selectedJob
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.jobButton.updateTitle(newValue)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedSubJob
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.subJobButton.updateTitle(newValue)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedExperience
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.experienceButton.updateTitle(newValue)
            }
            .store(in: &cancellables)
    }
    
    private func SubStackView(label: UILabel, button: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .vertical
        stackView.spacing = 4 // ✅ 라벨과 버튼 간격 (4px)
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
    
    private func createTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.pretendardStyle = .caption1
        label.textColor = .bblack
        return label
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
    
    private func showCustomModal(selectionType: ProfileSettingViewModel.SelectionType) {
        guard let parentVC = view.findViewController() else { return }
        
        let headerTitle = viewModel.getTitle(for: selectionType)
        let options = viewModel.getOptions(for: selectionType)
        let selectedOption = viewModel.getSelection(for: selectionType)
        let modal = SelectionModal(headerTitle: headerTitle, options: options, selectionType: selectionType, delegate: self, selectedOption: selectedOption)
        
        let customTransitionDelegate = ModalTransitioningDelegate()
        modal.modalPresentationStyle = .custom
        modal.transitioningDelegate = customTransitionDelegate
        
        parentVC.present(modal, animated: true)
    }
}
