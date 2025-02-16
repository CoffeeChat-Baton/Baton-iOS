import UIKit

class BaseTextView: UIView, UITextViewDelegate {
    
    private let textView = UITextView()
    
    var onTextChanged: ((String) -> Void)?
    var placeholder: String = ""
    
    init(frame: CGRect = .zero, placeholder: String) {
        super.init(frame: frame)
        setupView(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(placeholder: String) {
        self.placeholder = placeholder
        backgroundColor = .white
        layer.cornerRadius = CornerRadius.button.value
        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .gray3).cgColor

        textView.text = placeholder
        textView.textColor = UIColor.gray4
        textView.font = UIFont.Pretendard.body5.font
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false // 내용이 많아지면 자동으로 크기 확장 가능

        addSubview(textView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    // 텍스트 변경 감지
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text)
    }

    // placeholder 기능 (처음엔 placeholder 보이고, 입력하면 사라지도록)
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
