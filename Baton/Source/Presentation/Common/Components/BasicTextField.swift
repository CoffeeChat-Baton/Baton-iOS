import UIKit

class BasicTextField: UIView, UITextFieldDelegate {
    
    private let textField = UITextField()
    
    var onTextChanged: ((String) -> Void)?

    init(frame: CGRect = .zero, placeholder: String) {
        super.init(frame: frame)
        setupView(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(placeholder: String) {
        backgroundColor = .white
        layer.cornerRadius = CornerRadius.button.value
        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .gray3).cgColor

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.gray4]
        )
        textField.font = UIFont.Pretendard.body5.font
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always

        addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    @objc private func textChanged() {
        onTextChanged?(textField.text ?? "")
    }

    /// ✅ `Return` 키를 누르면 키보드 숨김
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
