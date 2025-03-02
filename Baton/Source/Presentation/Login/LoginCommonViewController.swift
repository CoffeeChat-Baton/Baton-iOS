import UIKit
import Combine

class LoginCommonViewController: BaseViewController<LoginViewModel> {
    
    init(viewModel: LoginViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: { viewModel.goToNextStep() })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
