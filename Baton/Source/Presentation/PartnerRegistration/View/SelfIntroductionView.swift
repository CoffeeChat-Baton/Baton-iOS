import UIKit
import Combine

class SelfIntroductionView: BaseViewController<PartnerRegistrationViewModel> {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    private let shortIntroLabel = SelectionTitleLabel(title: "한 줄 소개")
    private let shortIntroTextField = BasicTextField(placeholder: "한 줄 소개를 작성해주세요")
    
    private let detailedBioTitleLabel = SelectionTitleLabel(title: "상세소개")
    private let detailedBioTextField = BaseTextView(placeholder: "자신을 소개하는 글을 작성해주세요")
    
    // MARK: - Init
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
    
    // MARK: - UI Setup
    private func setupView() {}
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            SubStackView(label: shortIntroLabel, view: shortIntroTextField),
            SubStackView(label: detailedBioTitleLabel, view: detailedBioTextField),
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
                
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           
            shortIntroTextField.heightAnchor.constraint(equalToConstant: 48),
            detailedBioTextField.topAnchor.constraint(equalTo: detailedBioTitleLabel.bottomAnchor),
            detailedBioTextField.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])
    }
    
    // MARK: - Load Options
    private func bindViewModel() {
        shortIntroTextField.onTextChanged = { [weak self] text in
            self?.viewModel.shortIntro = text
        }
        detailedBioTextField.onTextChanged = { [weak self] text in
            self?.viewModel.detailedBio = text
        }
    }
}

