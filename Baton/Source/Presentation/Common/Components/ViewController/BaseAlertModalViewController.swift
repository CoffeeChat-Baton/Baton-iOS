import UIKit

class BaseAlertModalViewController: UIViewController {
    
    // ✅ 알림창 컨테이너
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .bwhite
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ✅ 메인 타이틀
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .title1
        label.textColor = UIColor(named: "bblack")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ✅ 서브 타이틀
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "서브 타이틀 예제입니다."
        label.textColor = UIColor(named: "gray5")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.pretendardStyle = .body5 // ✅ text 설정 후 스타일 적용
        return label
    }()
    
    // ✅ 동적 컨텐츠를 담을 스택뷰
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // ✅ 닫기 버튼
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2.font
        button.backgroundColor = .gray2
        button.setTitleColor(UIColor.bblack, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ✅ 액션 버튼 (기본 숨김)
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Pretendard.body1.font
        button.backgroundColor = .bblack
        button.setTitleColor(.bwhite, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ✅ 버튼 액션 핸들러
    var actionHandler: (() -> Void)?
    // ✅ 컨텐츠 스택뷰의 Dynamic Constraint
    private var contentStackViewTopConstraint: NSLayoutConstraint?
    
    // ✅ 생성자
    init(title: String, subtitle: String, closeTitle: String = "닫기", actionTitle: String? = nil, actionHandler: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.closeButton.setTitle(closeTitle, for: .normal)
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.actionHandler = actionHandler
        
        if let actionTitle = actionTitle {
            self.actionButton.setTitle(actionTitle, for: .normal)
        } else {
            self.actionButton.isHidden = true
        }
        
        self.closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        self.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(contentStackView)
        containerView.addSubview(closeButton)
        containerView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            closeButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 30),
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -6),
            closeButton.heightAnchor.constraint(equalToConstant: 52),
            
            actionButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 6),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 52),
            
            containerView.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20)
        ])
        
        // ✅ contentStackView의 Dynamic Constraint 추가
        contentStackViewTopConstraint = contentStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 0) // 기본은 0
        contentStackViewTopConstraint?.isActive = true
    }
    
    // ✅ 모달 닫기
    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    // ✅ 액션 버튼 클릭
    @objc func actionButtonTapped() {
        dismiss(animated: true) {
            self.actionHandler?()
        }
    }
    
    // ✅ 동적으로 뷰 추가
    func addContentView(_ view: UIView) {
        contentStackView.addArrangedSubview(view)
        contentStackViewTopConstraint?.constant = 30
    }
}



import SwiftUI

struct AlertModalPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BaseAlertModalViewController {
        let modal = BaseAlertModalViewController(
            title: "작성을 그만두시겠어요?",
            subtitle: "작성 중인 내용은 저장되지 않아요",
            actionTitle: "그만두기",
            actionHandler: {
                print("✅ 확인 버튼 클릭됨")
            }
        )
        return modal
    }
    
    func updateUIViewController(_ uiViewController: BaseAlertModalViewController, context: Context) {}
}

struct AlertModal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // ✅ 반투명 배경 추가
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            AlertModalPreview()
                .edgesIgnoringSafeArea(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}

