import UIKit
import Combine

extension ApplyBatonViewController: BatonNavigationConfigurable {
    @objc func baseBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ApplyBatonViewController: ApplyScheduleSelectionModalDelegate {
    func didSelectSchedule(index: Int, date: String, startTime: String, endTime: String) {
       
        let title = formatteSchdule(date: date, startTime: startTime, endTime:  endTime)
        // 3. 해당 index의 버튼 제목 업데이트
        DispatchQueue.main.async {
            if index < self.scheduleButtons.count {
                print(index)
                let schedule = Schedule(date: date, startTime: startTime, endTime: endTime)
                self.viewModel.updateSchedule(index: index, schedule: schedule)
            }
        }
    }
}
extension ApplyBatonViewController: AttachmentPickerDelegate {
    func didSelectFile(_ fileName: String, fileURL: URL) {
        print(fileName)
    }
}

class ApplyBatonViewController: UIViewController {
    private let viewModel: ApplyBatonViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private static func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.pretendardStyle = .body1
        label.textColor = UIColor(resource: .bblack)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
    private static func makeSubtitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.pretendardStyle = .caption2
        label.textColor = UIColor(resource: .gray5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
    private static func makeContainerView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let view = UIStackView()
        view.axis = axis
        view.spacing = spacing
        view.distribution = distribution
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var timeLabel: UILabel = makeTitleLabel(text: "시간을 선택해주세요")
    private let timeContainerView: UIStackView = makeContainerView(axis: .horizontal, spacing: 6, distribution: .fillEqually)
    private var scheduleLabel: UILabel = makeTitleLabel(text: "가능한 일정을 추가해주세요")
    private var scheduleSubLabel: UILabel = makeSubtitleLabel(text: "제안하는 3개 일정 중 파트너가 1개를 선택하여 확정됩니다.")
    private let scehduleStackView: UIStackView = makeContainerView(axis:.vertical, spacing: 6, distribution: .fillEqually)
    private var questionLabel: UILabel = makeTitleLabel(text: "사전질문을 작성해주세요")
    private let questionView = BaseTextView(placeholder: "사전 질문을 작성해주세요", maxLength: 3000)
    private let attachedFileStackView = makeContainerView(axis: .horizontal, spacing: 4)
    private let fileLabel = makeTitleLabel(text: "첨부파일")
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .caption2
        label.textColor = .main
        label.text = "(선택)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let attachmentPicker = AttachmentPickerView(placeholder: "파일을 업로드해주세요")

    // 4. 하단 고정 버튼
    lazy var actionButton: BasicButton = {
        let button = BasicButton(title: "다음", status: .enabled)
        button.isEnabled = true // 초기에는 비활성화
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private var selectedButton: BatonApplyButton? // 현재 선택된 버튼
    private var selectedButtonType: String? // 선택된 버튼 타입
    
    private var timeButtons = [
        MultiSelectTimeButton(time: 20, price: 14900),
        MultiSelectTimeButton(time: 30, price: 19900),
        MultiSelectTimeButton(time: 40, price: 39900),
    ]
    
    private var scheduleButtons = [
        SelectionButton(placeholder: "첫 번째 일정을 선택해주세요"),
        SelectionButton(placeholder: "두 번째 일정을 선택해주세요"),
        SelectionButton(placeholder: "세 번째 일정을 선택해주세요"),
    ]

    init() {
        self.viewModel = ApplyBatonViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        bindViewModel()
        setupTimeButtonsSelection()
        setupScheduleButtonsSelection()
        
        scrollView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.hideTabBar()
        }
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let backButton = BatonNavigationButton.backButton(target: self, action: #selector(baseBackButtonTapped))
        setupBaseNavigationBar(title: "신청하기", backButton: backButton)
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // ✅ 스크롤뷰의 contentSize를 강제 설정
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.height)

        print("✅ 강제 설정 후 scrollView.contentSize:", scrollView.contentSize)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("📌 view.frame: \(view.frame)")
        print("📌 scrollView.frame: \(scrollView.frame)")
        print("📌 contentView.frame: \(contentView.frame)")
        print("📌 scrollView.contentSize: \(scrollView.contentSize)")
    }
    
    private func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        questionView.translatesAutoresizingMaskIntoConstraints = false
        attachmentPicker.translatesAutoresizingMaskIntoConstraints = false
        questionView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentInsetAdjustmentBehavior = .never
        attachmentPicker.delegate = self
        
        view.backgroundColor = .bwhite
        view.addSubview(scrollView)
        view.addSubview(actionButton)

        scrollView.addSubview(contentView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeContainerView)
        timeContainerView.isUserInteractionEnabled = true
        for (index, button) in timeButtons.enumerated() {
            button.tag = index
            button.isUserInteractionEnabled = true
            timeContainerView.addArrangedSubview(button)
        }
        contentView.addSubview(scheduleLabel)
        contentView.addSubview(scheduleSubLabel)
        contentView.addSubview(scehduleStackView)
        
        for button in scheduleButtons {
            scehduleStackView.addArrangedSubview(button)
        }
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionView)
        contentView.addSubview(attachedFileStackView)
        contentView.addSubview(attachmentPicker)

        attachedFileStackView.addArrangedSubview(fileLabel)
        attachedFileStackView.addArrangedSubview(optionLabel)
        attachedFileStackView.addArrangedSubview(UIView())
    }

    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            // 하단 고정 버튼 제약 조건
            actionButton.heightAnchor.constraint(equalToConstant: ButtonSize.large.height),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            // scrollView의 frameLayoutGuide를 view에 맞춤
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            
            // contentView를 scrollView의 contentLayoutGuide에 연결
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1200),
            // --- 아래는 contentView 내부 서브뷰 제약 조건 ---
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            timeLabel.heightAnchor.constraint(equalToConstant: 26),
            
            timeContainerView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 14),
            timeContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            timeContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            timeContainerView.heightAnchor.constraint(equalToConstant: 106),
            
            scheduleLabel.topAnchor.constraint(equalTo: timeContainerView.bottomAnchor, constant: 36),
            scheduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            scheduleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 26),
            
            scheduleSubLabel.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 4),
            scheduleSubLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            scheduleSubLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            scheduleSubLabel.heightAnchor.constraint(equalToConstant: 18),
            
            scehduleStackView.topAnchor.constraint(equalTo: scheduleSubLabel.bottomAnchor, constant: 14),
            scehduleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            scehduleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            scehduleStackView.heightAnchor.constraint(equalToConstant: 162),
            
            questionLabel.topAnchor.constraint(equalTo: scehduleStackView.bottomAnchor, constant: 36),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            questionLabel.heightAnchor.constraint(equalToConstant: 26),
            
            questionView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 14),
            questionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            questionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            questionView.heightAnchor.constraint(equalToConstant: 500),
            
            attachedFileStackView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 36),
            attachedFileStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            attachedFileStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            attachmentPicker.topAnchor.constraint(equalTo: attachedFileStackView.bottomAnchor, constant: 14),
            attachmentPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            attachmentPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
        ])
    }
    
    private func setupTimeButtonsSelection() {
        for button in timeButtons {
            button.onSelectionChanged = { [weak self, weak button] isSelected in
                guard let self = self, let tappedButton = button else { return }
                if isSelected {
                    self.viewModel.updateTime(index: button?.tag ?? 0)
                    // tappedButton이 선택되었으므로 다른 버튼들은 해제
                    for otherButton in self.timeButtons where otherButton !== tappedButton {
                        otherButton.isSelectedState = false
                    }
                }
            }
        }
    }
    
    private func setupScheduleButtonsSelection() {
        for button in scheduleButtons {
            button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        }
    }
    
    private func bindViewModel() {
        viewModel.$schedules
            .sink { selectedSchedules in
                
                for (index, button) in self.scheduleButtons.enumerated(){
                    let schedule = selectedSchedules[index]
                    if schedule.date.isEmpty {
                        button.updateTitle("")
                    } else {
                        let title = self.formatteSchdule(date: schedule.date, startTime: schedule.startTime, endTime: schedule.endTime)
                        button.updateTitle(title)
                    }
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func formatteSchdule(date: String, startTime: String, endTime: String) -> String{
        // 1. 선택한 날짜를 "YYYY-MM-DD" → "MM월 DD일 (요일)" 형태로 변환
        let formattedDate = DateUtil.formatToKoreanDate(date) ?? date
        
        // 2. 최종 표시할 텍스트 생성
        let title = "\(formattedDate) \(startTime) ~ \(endTime)"  // 예: "10월 31일 (금) 14:00 ~ 16:00"
        
        return title
    }
    
    // MARK: - Button Actions
    // ✅ "다음" 버튼 클릭 시 선택된 버튼 타입에 따라 다른 화면으로 이동
    @objc private func actionButtonTapped() {
        viewModel.updateQuestion(questionView.content)
        if let content = attachmentPicker.content {
            viewModel.updateAttachedFile(content)
        }
        print("다음 버튼 클릭됨")
        let nextVC = ApplyBatonCompleteViewController(price: 14900)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // ✅  버튼 클릭 시 호출됨 (어떤 버튼이 눌렸는지 `sender.tag`로 구분 가능)
    @objc private func scheduleButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        sender.setTitleColor(.black, for: .normal)
        showCustomModal(for: selectedIndex)
    }

    // MARK: - Modal Animation
    /// ✅ 특정 일정 선택 버튼을 눌렀을 때 모달을 표시
    private func showCustomModal(for index: Int) {
        guard let parentVC = view.findViewController() else { return }
        let modal = ApplyScheduleSelectionModal(index: index, date: "", startTime: "", endTime: "")
        modal.delegate = self
        
        let customTransitionDelegate = ModalTransitioningDelegate()
        modal.modalPresentationStyle = .custom
        modal.transitioningDelegate = customTransitionDelegate
        parentVC.present(modal, animated: true)
    }
}

#if DEBUG
import SwiftUI

struct ApplyBatonViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ApplyBatonViewController {
        return ApplyBatonViewController()
    }

    func updateUIViewController(_ uiViewController: ApplyBatonViewController, context: Context) {}
}

struct ApplyBatonViewController_Previews: PreviewProvider {
    static var previews: some View {
        ApplyBatonViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
    }
}
#endif
