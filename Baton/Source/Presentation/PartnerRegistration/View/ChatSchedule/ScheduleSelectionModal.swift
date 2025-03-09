import UIKit
import Combine

protocol ScheduleSelectionModalDelegate: AnyObject {
    func didSelectSchedule(index: Int, days: [String], startTime: String, endTime: String)
}

class ScheduleSelectionModal: UIViewController {
    weak var delegate: ScheduleSelectionModalDelegate?
    private let viewModel: ScheduleSelectionViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let ordinalNumbers = ["첫", "두", "세"]
    private let days: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    private var dayButtons: [MulitSelectButton] = []
    private let weedayButton = MulitSelectButton(title: "평일")
    private let weekendButton = MulitSelectButton(title: "주말")
    
    
    private let modalView = UIView()
    private let headerView: ModalHeaderView
    
    private let dayTitleLabel = SelectionTitleLabel(title: "요일", style: .body4, color: .bblack)
    private let timeTitleLabel = SelectionTitleLabel(title: "시간", style: .body4, color: .bblack)
    
    private let daySelectionStackView = UIStackView()
    private let timeSelectionStackView = UIStackView()
    private let timeRangeLabel = SelectionTitleLabel(title: "~", style: .head1, color: .gray3)
    private let startTimePicker = CustomTimePickerButton()
    private let endTimePicker = CustomTimePickerButton()
    
    private var modalHeightConstraint: NSLayoutConstraint?

    private var actionButton: BasicButton = {
        let button = BasicButton(title: "확인", status: .enabled)
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(index: Int, selectedDays: Set<String>, startTime: String, endTime: String ){
        self.viewModel = ScheduleSelectionViewModel(index: index, selectedDays: selectedDays, startTime: startTime, endTime: endTime)
        let headerTitle = ordinalNumbers[index] + "번째 일정"
        self.headerView = ModalHeaderView(title: headerTitle)
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
        addSubViews()
        setupConstraint()
        setupAction()
        animateModalAppearance()
        bindViewModel()
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.$selectedDays
            .sink { selectedDays in
                print("현재 선택된 요일: \(selectedDays)")
            }
            .store(in: &cancellables)
        
        viewModel.$startTime
            .sink { selectedTime in
                self.startTimePicker.updateTitle(selectedTime)
            }
            .store(in: &cancellables)
        
        viewModel.$endTime
            .sink { selectedTime in
                self.endTimePicker.updateTitle(selectedTime)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .clear

        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 16
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        daySelectionStackView.axis = .horizontal
        daySelectionStackView.spacing = 3
        daySelectionStackView.distribution = .fillEqually
        
        timeSelectionStackView.axis = .horizontal
        timeSelectionStackView.spacing = 16
        timeSelectionStackView.distribution = .fill
    }
    
    private func addSubViews() {
        view.addSubview(modalView)
        modalView.addSubview(headerView)
        modalView.addSubview(actionButton)
        
        modalView.addSubview(dayTitleLabel)
        modalView.addSubview(daySelectionStackView)

        modalView.addSubview(timeTitleLabel)
        modalView.addSubview(timeSelectionStackView)
        
        timeSelectionStackView.addArrangedSubview(startTimePicker)
        timeSelectionStackView.addArrangedSubview(timeRangeLabel)
        timeSelectionStackView.addArrangedSubview(endTimePicker)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        dayTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        daySelectionStackView.translatesAutoresizingMaskIntoConstraints = false
        timeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeSelectionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 월 - 금 버튼
        for day in days {
            let button = MulitSelectButton(title: day)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.onSelectionChanged = { [weak self] isSelected in
                self?.viewModel.updateSelection(day: day, isSelected: isSelected)
            }
            dayButtons.append(button)
            daySelectionStackView.addArrangedSubview(button)
        }
        
        timeRangeLabel.setContentHuggingPriority(.required, for: .horizontal)
        startTimePicker.setContentHuggingPriority(.defaultLow, for: .horizontal)
        endTimePicker.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        timeRangeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        startTimePicker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        endTimePicker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupConstraint(){

        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            headerView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: modalView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),
            
            dayTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 17),
            dayTitleLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            dayTitleLabel.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            dayTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            daySelectionStackView.topAnchor.constraint(equalTo: dayTitleLabel.bottomAnchor, constant: 11),
            daySelectionStackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            daySelectionStackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            daySelectionStackView.heightAnchor.constraint(equalToConstant: 44),
            
            timeTitleLabel.topAnchor.constraint(equalTo: daySelectionStackView.bottomAnchor, constant: 17),
            timeTitleLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            timeTitleLabel.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            timeTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            timeSelectionStackView.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 11),
            timeSelectionStackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            timeSelectionStackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            timeSelectionStackView.heightAnchor.constraint(equalToConstant: 50),
            timeSelectionStackView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -70),
            
            timeRangeLabel.heightAnchor.constraint(equalToConstant: 34),
            timeRangeLabel.widthAnchor.constraint(equalToConstant: 15),
            

            // 버튼들이 남는 공간을 동일하게 차지하도록 설정
            startTimePicker.widthAnchor.constraint(equalTo: endTimePicker.widthAnchor),
              
            actionButton.heightAnchor.constraint(equalToConstant: 52),
            actionButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            actionButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -20),
        ])

    }
    
    private func setupAction() {
        headerView.onCloseTapped = { [weak self] in
            self?.dismissModal()
        }
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        startTimePicker.onTimeSelected = { [weak self] selectedTime in
            self?.viewModel.updateStartTime(selectedTime)
        }
        
        endTimePicker.onTimeSelected = { [weak self] selectedTime in
            self?.viewModel.updateEndTime(selectedTime)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button Actions

    @objc private func actionButtonTapped(){
        dismissModal()
        let index = viewModel.index
        let days = Array(viewModel.selectedDays)
        let startTime = viewModel.startTime
        let endTime = viewModel.endTime
        
        self.delegate?.didSelectSchedule(index: index, days: days, startTime: startTime, endTime: endTime)
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.modalView.transform = CGAffineTransform(translationX: 0, y: self.modalView.frame.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: - Modal Animation
    private func animateModalAppearance() {
        modalView.transform = CGAffineTransform(translationX: 0, y: modalView.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.modalView.transform = .identity
        }
    }
    
}
