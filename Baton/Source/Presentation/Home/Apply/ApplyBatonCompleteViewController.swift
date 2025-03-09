import UIKit
import Combine

extension ApplyBatonCompleteViewController: BatonNavigationConfigurable {
    @objc func baseBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

class ApplyBatonCompleteViewController: UIViewController {
    private let viewModel: ApplyBatonViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private static func makeMainTitleLabel(text: String) -> UILabel {
        return UILabel.makeLabel(text: text, textColor: .bblack, fontStyle: .head1)
    }
    
    private static func makeTitleLabel(text: String) -> UILabel {
        return UILabel.makeLabel(text: text, textColor: .bblack, fontStyle: .body3)
    }
    
    private static func makeSubtitleLabel(text: String) -> UILabel {
        return UILabel.makeLabel(text: text, textColor: .gray5, fontStyle: .caption2)
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
    private let mainTitleLabel: UILabel = makeMainTitleLabel(text: "신청 정보를 확인해주세요")
    private let subTitleLabel: UILabel = makeSubtitleLabel(text: "신청 후에는 신청 정보를 수정할 수 없어요")
    
    private let mentoInfomationLabel: UILabel = makeTitleLabel(text: "파트너 정보")
    private let profileView = BatonProfileView(
        image: UIImage(resource: .profileDefault),
        name: "박그냥",
        company: "네이버", category: "개발",
        description: "iOS 개발 | 4년차",
        buttonTitle: "바통 입장하기",
        info: false
    )
    private let timeAndScheduleLabel: UILabel = makeTitleLabel(text: "희망하는 시간 및 일정")
    
    private let timeTag = BatonTag(content: "20", type: .time)
    private let timeStackView = UIView.makeContainerView(axis: .vertical, spacing: 6, distribution: .fillEqually)
    private var timeViews: [BaseTextView] = []
    private let questionLabel: UILabel = makeTitleLabel(text: "사전 질문")
    private let questionView = BaseTextView(
        placeholder: "네이버에 가고 싶었는데, 덕분에 어떻게 준비할지 감이 좀 잡힌 것 같습니다. 네이버에 가고 싶었는데, 덕분에 어떻게 준비할지 감이 좀 잡힌 것 같습니다. 네이버에 가고 싶었는데, 덕분에 어떻게 준비할지 감이 좀 잡힌 것 같습니다?",
        maxLength: 3000 ,
        style: .filled,
        isEditable: false
    )
    
    private let attachedFileLabel: UILabel = makeTitleLabel(text: "첨부 파일")
    private let attachmentPicker = AttachmentPickerView(placeholder: "파일을 업로드해주세요", isEditable: false)
    
    private let priceTitleLabel = UILabel.makeLabel(text: "결제 금액", textColor: .bblack, fontStyle: .body1)
    private lazy var priceLabel = UILabel.makeLabel(text: NumberFormatUtil.formatPrice(self.price) + "원", textColor: .main, fontStyle: .body1)
    private let price: Int
    
    private let spacer1 = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let spacer2 = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 4. 하단 고정 버튼
    lazy var actionButton: BasicButton = {
        let priceString = NumberFormatUtil.formatPrice(self.price)
        let button = BasicButton(title: priceString + "원 결제하기", status: .enabled)
        button.isEnabled = false // 초기에는 비활성화
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
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
    
    init(price: Int) {
        self.viewModel = ApplyBatonViewModel()
        self.price = price
        for _ in 0..<3 {
            self.timeViews.append(BaseTextView(placeholder: "hello", style: .filled, isEditable: false))
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        
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
        setupBaseNavigationBar(title: "바통 신청하기", backButton: backButton)
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
        profileView.translatesAutoresizingMaskIntoConstraints = false
        attachmentPicker.translatesAutoresizingMaskIntoConstraints = false
        questionView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTag.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .bwhite
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(actionButton)
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(spacer1)
        
        contentView.addSubview(mentoInfomationLabel)
        contentView.addSubview(profileView)
        profileView.updateBackgroundColorFilled()
        
        contentView.addSubview(timeAndScheduleLabel)
        contentView.addSubview(timeTag)
        contentView.addSubview(timeStackView)
        
        for view in timeViews {
            timeStackView.addArrangedSubview(view)
        }
        
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionView)
        contentView.addSubview(attachedFileLabel)
        contentView.addSubview(attachmentPicker)
        
        contentView.addSubview(spacer2)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
        priceLabel.textAlignment = .right
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.isScrollEnabled = true
    }
    
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // ✅ contentView를 scrollView에 맞춤
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 51),
         

            
            mainTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 31),
            mainTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            mainTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            spacer1.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 26),
            spacer1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacer1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacer1.heightAnchor.constraint(equalToConstant: 6),
            
            mentoInfomationLabel.topAnchor.constraint(equalTo: spacer1.bottomAnchor, constant: 24),
            mentoInfomationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            mentoInfomationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            profileView.topAnchor.constraint(equalTo: mentoInfomationLabel.bottomAnchor, constant: 12),
            profileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            profileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            timeAndScheduleLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 24),
            timeAndScheduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            timeAndScheduleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            timeTag.topAnchor.constraint(equalTo: timeAndScheduleLabel.bottomAnchor, constant: 12),
            timeTag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            
            timeStackView.topAnchor.constraint(equalTo: timeTag.bottomAnchor, constant: 12),
            timeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            timeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            timeStackView.heightAnchor.constraint(equalToConstant: 165),

            questionLabel.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            questionView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 12),
            questionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            questionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            attachedFileLabel.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 24),
            attachedFileLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            attachedFileLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            attachmentPicker.topAnchor.constraint(equalTo: attachedFileLabel.bottomAnchor, constant: 12),
            attachmentPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            attachmentPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            spacer2.topAnchor.constraint(equalTo: attachmentPicker.bottomAnchor, constant: 26),
            spacer2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacer2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacer2.heightAnchor.constraint(equalToConstant: 6),
            
            priceTitleLabel.topAnchor.constraint(equalTo: spacer2.bottomAnchor, constant: 24),
            priceTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            priceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            priceLabel.topAnchor.constraint(equalTo: spacer2.bottomAnchor, constant: 24),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            
            actionButton.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 24),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.large.value),
            actionButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    // MARK: - Modal Animation
    /// ✅ 특정 일정 선택 버튼을 눌렀을 때 모달을 표시
    private func showCustomModal(for index: Int) {
//        guard let parentVC = view.findViewController() else { return }
//        //        let modal = ApplyScheduleSelectionModal(index: index, date: "", startTime: "", endTime: "")
//        //        modal.delegate = self
//        
//        let customTransitionDelegate = ModalTransitioningDelegate()
        //        modal.modalPresentationStyle = .custom
        //        modal.transitioningDelegate = customTransitionDelegate
        //        parentVC.present(modal, animated: true)
    }
}

#if DEBUG
import SwiftUI

struct ApplyBatonCompleteViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ApplyBatonCompleteViewController {
        return ApplyBatonCompleteViewController(price: 14900)
    }
    
    func updateUIViewController(_ uiViewController: ApplyBatonCompleteViewController, context: Context) {}
}

struct ApplyBatonCompleteViewController_Previews: PreviewProvider {
    static var previews: some View {
        ApplyBatonCompleteViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
    }
}
#endif
