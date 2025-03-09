import UIKit
import Combine

protocol ApplyScheduleSelectionModalDelegate: AnyObject {
    func didSelectSchedule(index: Int, date: String, startTime: String, endTime: String)
}

extension ApplyScheduleSelectionModal: BatonCalendarDelegate {
    func didSelectDate(_ date: String) {
        self.viewModel.updateDate(date)
        print(date)
    }
}

class ApplyScheduleSelectionModal: UIViewController {
    weak var delegate: ApplyScheduleSelectionModalDelegate?
    private let viewModel: ApplyScheduleSelectionViewModel
    private var cancellables = Set<AnyCancellable>()
    private let modalView = UIView()
    private let headerView: ModalHeaderView
    
    private let calendar = BatonCalendarView()
    private let dayTitleLabel = SelectionTitleLabel(title: "요일", style: .body4, color: .bblack)
    private let timeTitleLabel = SelectionTitleLabel(title: "시간", style: .body4, color: .bblack)
    
    private let dayView: CheckDateView
    
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
    
    init(index: Int, date: String, startTime: String, endTime: String ){
        self.viewModel = ApplyScheduleSelectionViewModel(index: index, date: date, startTime: startTime, endTime: endTime)
        self.headerView = ModalHeaderView(title: "")
        self.dayView = CheckDateView(date: date)
        
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
        addSubViews()
        setupConstraint()
        setupAction()
        animateModalAppearance()
        bindViewModel()
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
        calendar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.$date
            .sink { selectedDate in
                self.dayView.updateDateLabel(selectedDate)
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
        
        timeSelectionStackView.axis = .horizontal
        timeSelectionStackView.spacing = 16
        timeSelectionStackView.distribution = .fill
    }
    
    private func addSubViews() {
        view.addSubview(modalView)
        modalView.addSubview(headerView)
        modalView.addSubview(actionButton)
        
        modalView.addSubview(calendar)
        modalView.addSubview(dayTitleLabel)
        modalView.addSubview(dayView)
        
        modalView.addSubview(timeTitleLabel)
        modalView.addSubview(timeSelectionStackView)
        
        timeSelectionStackView.addArrangedSubview(startTimePicker)
        timeSelectionStackView.addArrangedSubview(timeRangeLabel)
        timeSelectionStackView.addArrangedSubview(endTimePicker)
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        modalView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        dayView.translatesAutoresizingMaskIntoConstraints = false
        dayTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeSelectionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        timeRangeLabel.setContentHuggingPriority(.required, for: .horizontal)
        startTimePicker.setContentHuggingPriority(.defaultLow, for: .horizontal)
        endTimePicker.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        timeRangeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        startTimePicker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        endTimePicker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupConstraint(){
        modalHeightConstraint = modalView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        modalHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modalView.heightAnchor.constraint(equalToConstant: 740),

            headerView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: modalView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),
            
            calendar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 6),
            calendar.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            calendar.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            calendar.heightAnchor.constraint(equalToConstant: 360),
            
            dayTitleLabel.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 32),
            dayTitleLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            dayTitleLabel.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            dayTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            dayView.topAnchor.constraint(equalTo: dayTitleLabel.bottomAnchor, constant: 8),
            dayView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            dayView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            dayView.heightAnchor.constraint(equalToConstant: 48),
            
            timeTitleLabel.topAnchor.constraint(equalTo: dayView.bottomAnchor, constant: 17),
            timeTitleLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            timeTitleLabel.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            timeTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            timeSelectionStackView.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 8),
            timeSelectionStackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            timeSelectionStackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            timeSelectionStackView.heightAnchor.constraint(equalToConstant: 48),
            timeSelectionStackView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -40),
            
            timeRangeLabel.heightAnchor.constraint(equalToConstant: 34),
            timeRangeLabel.widthAnchor.constraint(equalToConstant: 15),
            

            // 버튼들이 남는 공간을 동일하게 차지하도록 설정
            startTimePicker.widthAnchor.constraint(equalTo: endTimePicker.widthAnchor),
              
            actionButton.heightAnchor.constraint(equalToConstant: 52),
            actionButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -Spacing.large.value),
            actionButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -51),
        ])

    }
    
    private func setupAction() {
        headerView.onCloseTapped = { [weak self] in
            print("닫아줘 모달")
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
        let date = viewModel.date
        let startTime = viewModel.startTime
        let endTime = viewModel.endTime
        
        self.delegate?.didSelectSchedule(index: index, date: date, startTime: startTime, endTime: endTime)
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


import SwiftUI

struct ApplyScheduleSelectionModalRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ApplyScheduleSelectionModal {
        return ApplyScheduleSelectionModal(
            index: 0,
            date: "",
            startTime: "",
            endTime: ""
        )
    }
    
    func updateUIViewController(_ uiViewController: ApplyScheduleSelectionModal, context: Context) {}
}

struct ApplyScheduleSelectionModal_Previews: PreviewProvider {
    static var previews: some View {
        ApplyScheduleSelectionModalRepresentable()
            .edgesIgnoringSafeArea(.all)
            .previewDisplayName("Apply Schedule Selection Modal")
    }
}
