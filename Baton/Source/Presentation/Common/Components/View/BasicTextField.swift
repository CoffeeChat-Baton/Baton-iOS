import UIKit

class BasicTextField: UIView, UITextFieldDelegate {
    
    private let textField = UITextField()
    private let countLabel = UILabel()
    private let maxLength: Int
    private let textFieldHeight: CGFloat // ✅ 텍스트 필드 높이를 조절할 수 있도록 추가
    
    var onTextChanged: ((String) -> Void)?
    
    init(frame: CGRect = .zero, placeholder: String, maxLength: Int = 20, textFieldHeight: CGFloat = 48) {
        self.maxLength = maxLength
        self.textFieldHeight = textFieldHeight
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
        
        // ✅ 텍스트 필드 설정
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
        
        // ✅ 글자 수 카운트 라벨
        countLabel.font = UIFont.Pretendard.caption2.font
        countLabel.textColor = .gray3
        countLabel.text = "0/\(maxLength)" // 초기값 설정
        countLabel.textAlignment = .right
        
        addSubview(textField)
        addSubview(countLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ✅ 텍스트 필드 높이를 동적으로 조절 가능하도록 설정
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            // ✅ 글자 수 라벨을 오른쪽 아래에 배치
            countLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    @objc private func textChanged() {
        if let text = textField.text {
            if text.count > maxLength {
                textField.text = String(text.prefix(maxLength)) // ✅ 글자 제한 적용
            }
            countLabel.text = "\(textField.text?.count ?? 0)/\(maxLength)"
            countLabel.textColor = text.count >= maxLength ? .red : .gray3 // ✅ 초과 시 빨간색 경고
        }
        onTextChanged?(textField.text ?? "")
    }
    
    /// ✅ `Return` 키를 누르면 키보드 숨김
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
