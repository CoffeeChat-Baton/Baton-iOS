import UIKit
import Combine

class EmployeeStatusView: BaseViewController<PartnerRegistrationViewModel> {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: PartnerRegistrationViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: {viewModel.goToNextStep()})
        setupView()
        setupStackView()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupView() {}
    private func setupStackView() {}
    
    // MARK: - Load Options
    private func bindViewModel() {}
}
