import UIKit

extension ApplyBatonViewController: BatonNavigationConfigurable {
    
    @objc func baseBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

class ApplyBatonViewController: UIViewController, AttachmentPickerDelegate {
    func didSelectFile(_ fileName: String, fileURL: URL) {
        print(fileName)
    }
    
    
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
    
    private static func makeContainerView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = spacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    var timeLabel: UILabel = makeTitleLabel(text: "시간을 선택해주세요")
    let timeContainerView: UIStackView = makeContainerView(axis: .horizontal, spacing: 6)
    var scheduleLabel: UILabel = makeTitleLabel(text: "가능한 일정을 추가해주세요")
    var scheduleSubLabel: UILabel = makeSubtitleLabel(text: "제안하는 3개 일정 중 파트너가 1개를 선택하여 확정됩니다.")
    let scehduleStackView: UIStackView = makeContainerView(axis:.vertical, spacing: 6)
    var questionLabel: UILabel = makeTitleLabel(text: "사전질문을 작성해주세요")
    let questionView = BaseTextView(placeholder: "사전 질문을 작성해주세요", maxLength: 3000)
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
        let button = BasicButton(title: "다음", status: .disabled)
        button.isEnabled = false // 초기에는 비활성화
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

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
//        setupButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.hideTabBar()
        }
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    private func setupNavigationBar() {
        let backButton = BatonNavigationButton.backButton(target: self, action: #selector(baseBackButtonTapped))
        setupBaseNavigationBar(title: "신청하기", backButton: backButton)
    }
    
    private func setupView() {
        attachmentPicker.delegate = self
        
        view.backgroundColor = .bwhite
        view.addSubview(timeLabel)
        view.addSubview(timeContainerView)
        view.addSubview(scheduleLabel)
        view.addSubview(scheduleSubLabel)
        view.addSubview(scehduleStackView)
        view.addSubview(actionButton)
        view.addSubview(questionLabel)
        view.addSubview(questionView)
        
        view.addSubview(attachedFileStackView)
        view.addSubview(attachmentPicker)

        attachedFileStackView.addArrangedSubview(fileLabel)
        attachedFileStackView.addArrangedSubview(optionLabel)
        attachedFileStackView.addArrangedSubview(UIView())

        
        timeContainerView.backgroundColor = .red
        scehduleStackView.backgroundColor = .red

    }
    
    private func setupConstraint() {
        questionView.translatesAutoresizingMaskIntoConstraints = false
        attachmentPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            timeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            timeContainerView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 14),
            timeContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            timeContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            timeContainerView.heightAnchor.constraint(equalToConstant: 106),

            scheduleLabel.topAnchor.constraint(equalTo: timeContainerView.bottomAnchor, constant: 36),
            scheduleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            scheduleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            scheduleSubLabel.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 4),
            scheduleSubLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            scheduleSubLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            scehduleStackView.topAnchor.constraint(equalTo: scheduleSubLabel.bottomAnchor, constant: 14),
            scehduleStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            scehduleStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            scehduleStackView.heightAnchor.constraint(equalToConstant: 162),
            
            questionLabel.topAnchor.constraint(equalTo: scehduleStackView.bottomAnchor, constant: 36),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            questionView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 14),
            questionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            questionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            questionView.heightAnchor.constraint(equalToConstant: 100),

            attachedFileStackView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 36),
            attachedFileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            attachedFileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            attachmentPicker.topAnchor.constraint(equalTo: attachedFileStackView.bottomAnchor, constant: 14),
            attachmentPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            attachmentPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            attachmentPicker.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.heightAnchor.constraint(equalToConstant: ButtonSize.large.height),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
        ])
    }
    
    // ✅ 버튼 선택 로직 설정
//    private func setupButtonActions() {
//        let buttons = [oneByoneButton, portfolioButton, resumeButton]
//        
//        for button in buttons {
//            button.onSelectionChanged = { [weak self] isSelected in
//                self?.handleButtonSelection(selectedButton: button, isSelected: isSelected)
//            }
//        }
//    }
//
//    // ✅ 선택된 버튼의 타입을 저장하도록 변경
//    private func handleButtonSelection(selectedButton: BatonApplyButton, isSelected: Bool) {
//        if let prevButton = self.selectedButton, prevButton != selectedButton {
//            prevButton.isSelectedState = false
//        }
//        
//        if isSelected {
//            self.selectedButton = selectedButton
//            
//            // ✅ 선택된 버튼 타입 저장
//            if selectedButton == oneByoneButton {
//                selectedButtonType = "1:1 바통"
//            } else if selectedButton == portfolioButton {
//                selectedButtonType = "포트폴리오 리뷰"
//            } else if selectedButton == resumeButton {
//                selectedButtonType = "이력서 첨삭"
//            }
//            
//            actionButton.isEnabled = true // ✅ 선택되면 "다음" 버튼 활성화
//            actionButton.status = .enabled
//        } else {
//            self.selectedButton = nil
//            selectedButtonType = nil
//            actionButton.isEnabled = false // ✅ 선택 해제되면 "다음" 버튼 비활성화
//            actionButton.status = .disabled
//        }
//    }

    // ✅ "다음" 버튼 클릭 시 선택된 버튼 타입에 따라 다른 화면으로 이동
    @objc private func actionButtonTapped() {
        let nextVC = HomeViewController()
        navigationController?.pushViewController(nextVC, animated: true)
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
