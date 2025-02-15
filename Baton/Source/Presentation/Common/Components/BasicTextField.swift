import UIKit

class BasicTextField: UIView {
    
    private let textField = UITextField()
    
    var onTextChanged: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = CornerRadius.button.value
        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .gray3).cgColor

        textField.attributedPlaceholder = NSAttributedString(
                string: "회사명을 입력하세요",
                attributes: [.foregroundColor: UIColor.gray4] 
            )
        textField.font = UIFont.Pretendard.body5.font
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .none
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
            heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func textChanged() {
        onTextChanged?(textField.text ?? "")
    }
}
