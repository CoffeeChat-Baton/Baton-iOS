import UIKit
import Combine

class ChatScheduleView: BaseViewController<PartnerRegistrationViewModel>, ScheduleSelectionModalDelegate {
    func didSelectSchedule(days: [String], startTime: String, endTime: String) {
        print("")
    }
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    /// ✅ 버튼 배열 (각 버튼이 일정 선택을 위한 버튼)
    private let scheduleButtons: [SelectionButton] = [
        SelectionButton(placeholder: "첫 번째 일정을 선택해주세요"),
        SelectionButton(placeholder: "두 번째 일정을 선택해주세요"),
        SelectionButton(placeholder: "세 번째 일정을 선택해주세요")
    ]
    
    // MARK: - Init
    init(viewModel: PartnerRegistrationViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: { viewModel.goToNextStep() })
        setupView()
        setupStackView()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupView() {
        // ✅ 버튼 초기 세팅 (플레이스홀더 적용 & 클릭 이벤트 추가)
        for (index, button) in scheduleButtons.enumerated() {
            button.tag = index  // ✅ 버튼의 index를 태그로 설정하여 눌린 버튼 식별 가능
            button.setTitleColor(UIColor(resource: .gray4), for: .normal)
            button.addTarget(self, action: #selector(scheduleButtonTapped(_:)), for: .touchUpInside)
        }
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: scheduleButtons)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 150) // ✅ 적절한 높이 설정
        ])
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        /// ✅ schedules 배열이 변경될 때 버튼의 타이틀 업데이트
        viewModel.$schedules
            .receive(on: RunLoop.main)
            .sink { [weak self] newSchedules in
                guard let self = self else { return }
                
                for (index, schedule) in newSchedules.enumerated() {
                    if index < self.scheduleButtons.count {
                        self.scheduleButtons[index].updateTitle(schedule)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Button Actions
    /// ✅ 버튼 클릭 시 호출됨 (어떤 버튼이 눌렸는지 `sender.tag`로 구분 가능)
    @objc private func scheduleButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        sender.setTitleColor(.black, for: .normal)
        showCustomModal(for: selectedIndex)
    }

    // MARK: - Modal Animation
    /// ✅ 특정 일정 선택 버튼을 눌렀을 때 모달을 표시
    private func showCustomModal(for index: Int) {
        guard let parentVC = view.findViewController() else { return }
        let ordinalNumbers = ["첫", "두", "셋"]
        let modal = ScheduleSelectionModal(headerTitle: ordinalNumbers[index] + "번째 일정")
        modal.delegate = self
        parentVC.present(modal, animated: true)
    }
}
