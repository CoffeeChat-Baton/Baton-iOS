import UIKit
import Combine

class SetStatusView: BaseViewController<ProfileSettingViewModel> {
    private var cancellables = Set<AnyCancellable>()

    private let studentButton = MultiSelectImageButton(title: "학생", imageName: "student")
    private let workerButton = MultiSelectImageButton(title: "직장인", imageName: "worker")
    
    init(viewModel: ProfileSettingViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: { viewModel.goToNextStep() })
        setupView()
        setupLayout()
        setupBinding()   // bind View ↔ ViewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // 버튼 탭 시: ViewModel.status 변경
        studentButton.onSelectionChanged = { [weak self] isSelected in
            if isSelected {
                self?.viewModel.status = .student
            }
        }
        workerButton.onSelectionChanged = { [weak self] isSelected in
            if isSelected {
                self?.viewModel.status = .worker
            }
        }

        // 스택뷰에 두 버튼 배치
        let stack = UIStackView(arrangedSubviews: [studentButton, workerButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    private func setupLayout() {
        // 기타 레이아웃(필요에 따라)
    }

    /// View ↔ ViewModel Binding
    private func setupBinding() {
        // ViewModel.status가 변경될 때 두 버튼의 선택 상태 업데이트
        viewModel.$status
            .receive(on: RunLoop.main)
            .sink { [weak self] newStatus in
                guard let self = self else { return }
                // '학생'이면 studentButton만 선택, '직장인'이면 workerButton만 선택
                self.studentButton.isSelectedState = (newStatus == .student)
                self.workerButton.isSelectedState = (newStatus == .worker)
            }
            .store(in: &cancellables)
    }
}
