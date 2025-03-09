import UIKit

class SuccessBatonViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .successBaton) // ✅ 배경 이미지
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // ✅ 타이틀
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(resource: .bblack)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ✅ 서브타이틀
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray5
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // ✅ 줄 간격을 조절하기 위한 NSAttributedString 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 // 👉 원하는 줄 간격 설정 (예: 6pt)

        let attributedText = NSAttributedString(
            string: "이곳에 표시될 서브 타이틀입니다.",
            attributes: [
                .font: UIFont.Pretendard.body4.font,
                .foregroundColor: UIColor.gray5,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        label.attributedText = attributedText
        
        return label
    }()
    
    // ✅ 버튼 1
    private let primaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.main, for: .normal)
        button.titleLabel?.pretendardStyle = .body1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ✅ 버튼 2
    private let secondaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.main
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.pretendardStyle = .body1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ✅ 버튼 스택뷰
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // ✅ 아이콘 + 라벨 스택뷰
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let stepView = StepIndicatorView()
    
    private var primaryAction: (() -> Void)?
    private var secondaryAction: (() -> Void)?
    
    // ✅ 초기화
    init(title: String, subtitle: String, primaryButtonText: String, secondaryButtonText: String, primaryAction: (() -> Void)?, secondaryAction: (() -> Void)?, step: Int?) {
        super.init(nibName: nil, bundle: nil)
        
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        if primaryButtonText.isEmpty {
            primaryButton.isHidden = true
        }
        titleLabel.text = title
        subtitleLabel.text = subtitle
        primaryButton.setTitle(primaryButtonText, for: .normal)
        secondaryButton.setTitle(secondaryButtonText, for: .normal)
        
        if let step = step {
            stepView.currentStep = step
        } else {
            stepView.isHidden = true
        }
        
        // ✅ 버튼 액션 추가
        primaryButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // ✅ 버튼 액션
    @objc private func primaryButtonTapped() {
        primaryAction?()
    }
    
    @objc private func secondaryButtonTapped() {
        secondaryAction?()
    }
    
    // ✅ 레이아웃 설정
    private func setupLayout() {
        stepView.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(backgroundImageView, at: 0) // ✅ 배경 추가
        view.addSubview(contentStackView)
        view.addSubview(buttonStackView)
        view.addSubview(stepView)
        // ✅ 스택뷰에 요소 추가
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        
        buttonStackView.addArrangedSubview(primaryButton)
        buttonStackView.addArrangedSubview(secondaryButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 83),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large.value),
           
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large.value),
            
            stepView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 53),
            stepView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stepView.heightAnchor.constraint(equalToConstant: 50),

            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ✅ 버튼 스택뷰 (뷰 하단 고정)
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // ✅ 버튼 높이
            primaryButton.heightAnchor.constraint(equalToConstant: 50),
            secondaryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

#if DEBUG
import SwiftUI

struct SuccessBatonViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SuccessBatonViewController {
        return SuccessBatonViewController(
            title: "바통 신청이 완료되었어요",
            subtitle: "바통을 건넸어요!\n멘토님의 응답이 오면 알림을 통해 알려드릴게요",
            primaryButtonText: "신청 정보 상세보기",
            secondaryButtonText: "확인",
            primaryAction: {
                print("✅ 멘토 정보 확인 버튼 클릭")
            },
            secondaryAction: {
                print("✅ 확인 버튼 클릭")
            },
            step: 1
        )
    }

    func updateUIViewController(_ uiViewController: SuccessBatonViewController, context: Context) {}
}

struct SuccessViewController_Previews: PreviewProvider {
    static var previews: some View {
        SuccessBatonViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
    }
}
#endif

class StepIndicatorView: UIView {
    
    private let step1Line = UIView()
    private let step2Line = UIView()
    private let step3Line = UIView()
    private let step4Line = UIView()

    private let step1Circle = UIView()
    private let step2Circle = UIView()
    private let step3Circle = UIView()
    
    // ✅ 각 동그라미 아래 텍스트
    private let step1Label = UILabel()
    private let step2Label = UILabel()
    private let step3Label = UILabel()

    var currentStep: Int = 1 {
        didSet {
            updateStep()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // ✅ 선(Line) 스타일
        [step1Line, step2Line, step3Line, step4Line].forEach { line in
            line.backgroundColor = .bwhite
            addSubview(line)
        }
        
        // ✅ 원(Circle) 스타일
        [step1Circle, step2Circle, step3Circle].forEach { circle in
            circle.backgroundColor = .bwhite
            circle.layer.cornerRadius = 8
            circle.clipsToBounds = true
            addSubview(circle)
        }

        // ✅ 텍스트 스타일 설정
        [step1Label, step2Label, step3Label].forEach { label in
            label.textColor = .white
            label.font = UIFont.Pretendard.caption1.font
            label.textAlignment = .center
            addSubview(label)
        }

        // ✅ 텍스트 내용 설정
        step1Label.text = "바통 신청"
        step2Label.text = "멘토 수락"
        step3Label.text = "바통 확정"
        
        // ✅ 초기 색상 설정
        updateStep()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineHeight: CGFloat = 5
        let circleSize: CGFloat = 16
        let labelHeight: CGFloat = 20
        
        let totalWidth = bounds.width // 전체 뷰 너비
        let lineRatios: [CGFloat] = [0.2, 0.3, 0.3, 0.2] // ✅ 선 비율 (0.2 : 0.3 : 0.3 : 0.2)
        
        // ✅ 각 선(Line)의 너비를 계산
        let lineWidths = lineRatios.map { totalWidth * $0 }
        
        // ✅ 선(Line) 배치
        step1Line.frame = CGRect(x: 0, y: bounds.midY - (lineHeight / 2), width: lineWidths[0], height: lineHeight)
        step2Line.frame = CGRect(x: step1Line.frame.maxX, y: bounds.midY - (lineHeight / 2), width: lineWidths[1], height: lineHeight)
        step3Line.frame = CGRect(x: step2Line.frame.maxX, y: bounds.midY - (lineHeight / 2), width: lineWidths[2], height: lineHeight)
        step4Line.frame = CGRect(x: step3Line.frame.maxX, y: bounds.midY - (lineHeight / 2), width: lineWidths[3], height: lineHeight)

        // ✅ 원(Circle) 배치 - 선의 중앙에 위치
        step1Circle.frame = CGRect(
            x: step1Line.frame.maxX - (circleSize / 2),
            y: bounds.midY - (circleSize / 2),
            width: circleSize,
            height: circleSize
        )
        
        step2Circle.frame = CGRect(
            x: step2Line.frame.maxX - (circleSize / 2),
            y: bounds.midY - (circleSize / 2),
            width: circleSize,
            height: circleSize
        )
        
        step3Circle.frame = CGRect(
            x: step3Line.frame.maxX - (circleSize / 2),
            y: bounds.midY - (circleSize / 2),
            width: circleSize,
            height: circleSize
        )

        // ✅ 텍스트(Label) 배치 (각 원 아래)
        step1Label.frame = CGRect(
            x: step1Circle.frame.midX - 30, // 중앙 정렬
            y: step1Circle.frame.maxY + 4,
            width: 60,
            height: labelHeight
        )
        
        step2Label.frame = CGRect(
            x: step2Circle.frame.midX - 30,
            y: step2Circle.frame.maxY + 4,
            width: 60,
            height: labelHeight
        )

        step3Label.frame = CGRect(
            x: step3Circle.frame.midX - 30,
            y: step3Circle.frame.maxY + 4,
            width: 60,
            height: labelHeight
        )
    }
    
    private func updateStep() {
        // ✅ 1단계 활성화
        step1Line.backgroundColor = (currentStep >= 1) ? .main : .bwhite
        step1Circle.backgroundColor = (currentStep >= 1) ? .main : .bwhite
        step1Label.textColor = (currentStep >= 1) ? .blue3 : .gray4
        
        // ✅ 2단계 활성화
        step2Line.backgroundColor = (currentStep >= 2) ? .main : .bwhite
        step2Circle.backgroundColor = (currentStep >= 2) ? .main : .bwhite
        step2Label.textColor = (currentStep >= 2) ? .blue3 : .gray4

        // ✅ 3단계 활성화
        step3Line.backgroundColor = (currentStep >= 3) ? .main : .bwhite
        step3Circle.backgroundColor = (currentStep >= 3) ? .main : .bwhite
        step4Line.backgroundColor = (currentStep >= 3) ? .main : .bwhite
        step3Label.textColor = (currentStep >= 3) ? .blue3 : .gray4

    }
}

import SwiftUI

struct StepIndicatorViewRepresentable: UIViewRepresentable {
    @Binding var currentStep: Int
    
    func makeUIView(context: Context) -> StepIndicatorView {
        let stepView = StepIndicatorView()
        stepView.currentStep = currentStep
        return stepView
    }

    func updateUIView(_ uiView: StepIndicatorView, context: Context) {
        uiView.currentStep = currentStep
    }
}

struct StepIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(1) { currentStep in
            AnyView(
                VStack {
                    StepIndicatorViewRepresentable(currentStep: currentStep)
                        .frame(width: 300, height: 40)
                        .padding()
                    
                    Button("다음 단계") {
                        if currentStep.wrappedValue < 3 {
                            currentStep.wrappedValue += 1
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            )
        }
        .previewLayout(.sizeThatFits)
    }
}

// ✅ 상태 관리를 위한 Wrapper
struct StatefulPreviewWrapper<Value>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> AnyView
    
    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> AnyView) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
