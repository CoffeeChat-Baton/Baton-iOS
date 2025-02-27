import UIKit

class BaseTextView: UIView, UITextViewDelegate {
    
    enum ViewStyle {
        case outlined, filled
    }
    
    private let containerView = UIView() // ✅ 텍스트뷰를 감싸는 뷰 추가
    private let textView = UITextView()
    private let countLabel = UILabel()
    
    var onTextChanged: ((String) -> Void)?
    var placeholder: String
    var maxLength: Int
    
    init(
        frame: CGRect = .zero,
        placeholder: String,
        maxLength: Int = 200,
        style: ViewStyle = .outlined,
        isEditable: Bool = true
    ) {
        self.placeholder = placeholder
        self.maxLength = maxLength
        super.init(frame: frame)
        setupView(placeholder: placeholder)
        setupStyle(style)
        self.textView.isEditable = isEditable
        
        if !isEditable {
            countLabel.isHidden = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle(_ style: ViewStyle) {
        containerView.layer.cornerRadius = CornerRadius.button.value

        switch style {
        case .outlined:
            backgroundColor = .clear // ✅ 전체 뷰 배경 투명
            containerView.backgroundColor = .white
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor(resource: .gray3).cgColor
            textView.textColor = UIColor.gray4
        case .filled:
            containerView.backgroundColor = .gray1
            textView.textColor = UIColor.bblack

        }
    }
    
    private func setupView(placeholder: String) {
        textView.text = placeholder
        textView.textColor = UIColor.gray4
        textView.font = UIFont.Pretendard.body2.font
        textView.delegate = self
        textView.isScrollEnabled = false // ✅ 자동 크기 확장
        textView.backgroundColor = .clear

        // ✅ 글자 수 카운트 라벨 (텍스트뷰 바깥 아래 배치)
        countLabel.font = UIFont.Pretendard.body5.font
        countLabel.textColor = .gray4
        countLabel.text = "0/\(maxLength)"
        countLabel.textAlignment = .right
        
        addSubview(containerView)
        containerView.addSubview(textView)
        addSubview(countLabel) // ✅ countLabel을 containerView 바깥에 추가
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // ✅ 컨테이너(테두리 포함) 설정
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // ✅ 텍스트뷰 설정 (컨테이너 내부)
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8), // ✅ 컨테이너 안에서만 레이아웃 지정

            // ✅ 글자 수 라벨 (컨테이너 바깥)
            countLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // ✅ 텍스트 변경 감지 및 글자 수 업데이트
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxLength {
            textView.text = String(textView.text.prefix(maxLength)) // ✅ 글자 제한
        }
        countLabel.text = "\(textView.text.count)/\(maxLength)"
        countLabel.textColor = textView.text.count >= maxLength ? .red : .gray3 // ✅ 초과 시 빨간색 표시

        onTextChanged?(textView.text)
    }

    // ✅ placeholder 기능 (처음엔 placeholder 보이고, 입력하면 사라짐)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray4 {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.gray4
        }
    }
}
