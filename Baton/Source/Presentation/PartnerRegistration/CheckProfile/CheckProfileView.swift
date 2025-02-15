import UIKit
import Combine

extension CheckProfileView: SelectionModalDelegate {
    func didSelectOption(_ option: String, type: CheckProfileViewModel.SelectionType) {
        viewModel.updateSelection(for: type, with: option)
    }
}
class CheckProfileView: UIView, StepContentView {
    
    private let jobTitleLabel = SelectionTitleLabel(title: "직무")
    private let jobButton = SelectionButton()
    
    private let subJobTitleLabel = SelectionTitleLabel(title: "세부 직무")
    private let subJobButton = SelectionButton()
    
    private let experienceTitleLabel = SelectionTitleLabel(title: "총 경력")
    private let experienceButton = SelectionButton()
    
    private var viewModel: CheckProfileViewModel
    private var cancellables = Set<AnyCancellable>() // ✅ Combine 구독
    
    var onContentStateChanged: ((Bool) -> Void)?
    
    init(viewModel: CheckProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupStackView()
        bindViewModel()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        jobButton.setTitle("직무 선택", for: .normal)
        subJobButton.setTitle("세부 직무 선택", for: .normal)
        experienceButton.setTitle("경력 선택", for: .normal)
        
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
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jobButton.heightAnchor.constraint(equalToConstant: 48),
            subJobButton.heightAnchor.constraint(equalToConstant: 48),
            experienceButton.heightAnchor.constraint(equalToConstant: 48),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
    
    private func bindViewModel(){
        viewModel.$selectedJob
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.jobButton.setTitle(newValue, for: .normal)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedSubJob
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.subJobButton.setTitle(newValue, for: .normal)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedExperience
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.experienceButton.setTitle(newValue, for: .normal)
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
        label.textColor = .black
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
    
    private func showCustomModal(selectionType: CheckProfileViewModel.SelectionType) {
        guard let parentVC = findViewController() else { return }
        let modal = SelectionModal(viewModel: viewModel, selectionType: selectionType)
        modal.delegate = self
        parentVC.present(modal, animated: true)
    }    
}
