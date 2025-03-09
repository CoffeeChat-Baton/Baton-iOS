import UIKit

class BaseTextView: UIView, UITextViewDelegate {
    
    enum ViewStyle {
        case outlined, filled
    }
    
    private let containerView = UIView()
    private let textView = UITextView()
    private let countLabel = UILabel()
    
    var onTextChanged: ((String) -> Void)?
    
    private let placeholder: String
    private let maxLength: Int
    
    private var countLabelHeightConstraint: NSLayoutConstraint! // ✅ countLabel의 높이를 제어하는 제약 조건

    var content: String {
        return textView.text
    }
    
    init(
        placeholder: String,
        maxLength: Int = 200,
        style: ViewStyle = .outlined,
        isEditable: Bool = true
    ) {
        self.placeholder = placeholder
        self.maxLength = maxLength
        super.init(frame: .zero)
        setupUI()
        applyStyle(style)
        textView.isEditable = isEditable
        setCountLabelVisibility(isHidden: !isEditable) // ✅ 초기 상태 반영
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        // 텍스트뷰 설정
        textView.text = placeholder
        textView.textColor = .gray4
        textView.font = UIFont.Pretendard.body2.font
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        // 글자 수 표시 라벨 설정
        countLabel.font = UIFont.Pretendard.body5.font
        countLabel.textColor = .gray4
        countLabel.text = "0/\(maxLength)"
        countLabel.textAlignment = .right
        
        // UI 추가
        addSubview(containerView)
        containerView.addSubview(textView)
        addSubview(countLabel)
        
        // 오토레이아웃 설정
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countLabelHeightConstraint = countLabel.heightAnchor.constraint(equalToConstant: 20) // ✅ 기본 높이 설정

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),

            countLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countLabelHeightConstraint // ✅ countLabel의 높이를 동적으로 변경할 수 있도록 제약 추가
        ])
    }
    
    // MARK: - 스타일 적용
    private func applyStyle(_ style: ViewStyle) {
        containerView.layer.cornerRadius = CornerRadius.button.value
        switch style {
        case .outlined:
            containerView.backgroundColor = .white
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor(resource: .gray3).cgColor
            textView.textColor = .gray4
        case .filled:
            containerView.backgroundColor = .gray1
            textView.textColor = .bblack
        }
    }
    
    // ✅ countLabel을 숨길 때 높이를 `0`으로 설정
    func setCountLabelVisibility(isHidden: Bool) {
        countLabel.isHidden = isHidden
        countLabelHeightConstraint.constant = isHidden ? 0 : 20 // ✅ 숨기면 높이를 0으로 설정
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded() // ✅ 레이아웃을 부드럽게 업데이트
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxLength {
            textView.text = String(textView.text.prefix(maxLength))
        }
        countLabel.text = "\(textView.text.count)/\(maxLength)"
        
        UIView.animate(withDuration: 0.2) {
            self.countLabel.textColor = textView.text.count >= self.maxLength ? .red : .gray3
        }
        
        onTextChanged?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray4 {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .gray4
        }
    }
}

// MARK: - SwiftUI Preview
#if DEBUG
import SwiftUI

struct BaseTextViewRepresentable: UIViewRepresentable {
    let placeholder: String
    let maxLength: Int
    let style: BaseTextView.ViewStyle
    let isEditable: Bool
    
    func makeUIView(context: Context) -> BaseTextView {
        return BaseTextView(placeholder: placeholder, maxLength: maxLength, style: style, isEditable: isEditable)
    }

    func updateUIView(_ uiView: BaseTextView, context: Context) {}
}

struct BaseTextView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            BaseTextViewRepresentable(placeholder: "입력하세요", maxLength: 200, style: .outlined, isEditable: true)
                .frame(height: 150)
                .previewLayout(.sizeThatFits)
            
            BaseTextViewRepresentable(placeholder: "읽기 전용 필드", maxLength: 100, style: .filled, isEditable: false)
                .frame(height: 150)
                .previewLayout(.sizeThatFits)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}
#endif
