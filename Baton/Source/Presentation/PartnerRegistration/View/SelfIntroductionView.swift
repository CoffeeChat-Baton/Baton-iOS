import UIKit
import Combine

class SelfIntroductionView: BaseViewController<PartnerRegistrationViewModel> {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let shortIntroLabel = SelectionTitleLabel(title: "한 줄 소개", style: .body4 , color: .gray5 )
    private let shortIntroTextField = BaseTextView(placeholder: "한 줄 소개를 작성해주세요", maxLength: 50)
    
    private let detailedBioTitleLabel = SelectionTitleLabel(title: "상세 소개", style: .body4 , color: .gray5 )
    private let detailedBioTextField = BaseTextView(placeholder: "자신을 소개하는 글을 작성해주세요", maxLength: 5000)
    
    // MARK: - Init
    init(viewModel: PartnerRegistrationViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: {viewModel.goToNextStep()})
        setupView()
        setupLayout()
        bindViewModel()
        view.addTapToDismissKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupView() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        detailedBioTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(SubStackView(label: shortIntroLabel, view: shortIntroTextField))
        contentStackView.addArrangedSubview(SubStackView(label: detailedBioTitleLabel, view: detailedBioTextField))
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo:contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            shortIntroTextField.heightAnchor.constraint(equalToConstant: 104),
            
            detailedBioTextField.topAnchor.constraint(equalTo: detailedBioTitleLabel.bottomAnchor, constant: 6),
            detailedBioTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            detailedBioTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
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

