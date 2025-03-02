import UIKit
import Combine

class SetEmailView: BaseViewController<ProfileSettingViewModel> {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let emailLabel = SelectionTitleLabel(title: "이메일", style: .body4 , color: .gray5 )
    private let emailTextField = BaseTextView(placeholder: "example@email.com", maxLength: 100, isEditable: false)
    
    // MARK: - Init
    init(viewModel: ProfileSettingViewModel) {
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
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(SubStackView(label: emailLabel, view: emailTextField))
   
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

            emailTextField.heightAnchor.constraint(equalToConstant: 78),
        ])
    }
    
    // MARK: - Load Options
    private func bindViewModel() {
        emailTextField.onTextChanged = { [weak self] text in
            self?.viewModel.email = text
        }
    }
}

