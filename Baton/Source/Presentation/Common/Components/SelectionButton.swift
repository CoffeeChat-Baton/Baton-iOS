import UIKit

class SelectionButton: UIButton {
    enum Mode {
        case selection, uploadFile
        
        var backgroundColor: UIColor {
            switch self {
            case .selection: return .white
            case .uploadFile: return .gray1
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .selection: return .gray3
            case .uploadFile: return .gray4
            }
        }
        
        var updatedTitleColor: UIColor {
            switch self {
            case .selection: return .bblack
            default: return titleColor
            }
        }
        
        var hasBorder: Bool {
            return self == .selection
        }
        
        var icon: UIImage? {
            switch self {
            case .selection: return UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
            case .uploadFile: return UIImage(resource: .uploadFile)
            }
        }
    }
    
    private let iconImageView = UIImageView()
    private let titleLabelCustom = UILabel()
    private var title: String = ""
    private var placeholder: String = ""

    
    var mode: Mode = .selection
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.6 : 1.0
            }
        }
    }

    init(mode: Mode = .selection, placeholder: String, title: String = "") {
        super.init(frame: .zero)
        self.mode = mode
        self.placeholder = placeholder
        self.title = title
        
        updateUI ()
        setupTitle(title == "" ? placeholder : title )
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        // 기본 UI 설정
        backgroundColor = mode.backgroundColor
        layer.cornerRadius = CornerRadius.button.value
        layer.borderWidth = mode.hasBorder ? 1 : 0
        layer.borderColor = mode.hasBorder ? UIColor(resource: .gray3).cgColor : nil
        
        // 텍스트 설정
        titleLabelCustom.translatesAutoresizingMaskIntoConstraints = false
        titleLabelCustom.pretendardStyle = .body4
        titleLabelCustom.lineBreakMode = .byTruncatingTail
        
        // 아이콘 설정
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .bblack
        iconImageView.contentMode = .scaleAspectFit
        
        addSubview(titleLabelCustom)
        addSubview(iconImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.deactivate(self.constraints)
        
        switch mode {
        case .selection:
            layer.borderWidth = 1
            layer.borderColor = UIColor(resource: .gray3).cgColor
            iconImageView.isHidden = false
            
            NSLayoutConstraint.activate([
                // 텍스트는 왼쪽 정렬
                titleLabelCustom.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                titleLabelCustom.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 0),
                titleLabelCustom.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                // 화살표는 오른쪽 정렬
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
            
        case .uploadFile:
            layer.borderWidth = 0
            iconImageView.isHidden = false
            
            NSLayoutConstraint.activate([
                // 아이콘과 텍스트 모두 왼쪽 정렬
                iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                titleLabelCustom.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                titleLabelCustom.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                titleLabelCustom.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
    
    private func updateUI() {
        backgroundColor = mode.backgroundColor
        iconImageView.image = mode.icon
    }
    
    private func setupPlaceholder(_ placeholder: String) {
        titleLabelCustom.text = placeholder
        titleLabelCustom.textColor = mode.titleColor
    }
    
    func setupTitle(_ title: String) {
        if self.title == "" { // 입력한 값이 없는 경우 = Placeholder를 보여줘야 하는 경우
            titleLabelCustom.textColor = mode.titleColor
        } else {
            titleLabelCustom.textColor = mode.updatedTitleColor
        }
        titleLabelCustom.text = title
    }
    
    func updateTitle(_ title: String) {
        self.title = title

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleLabelCustom.text = placeholder
            titleLabelCustom.textColor = mode.titleColor
        } else {
            titleLabelCustom.text = title
            titleLabelCustom.textColor = mode.updatedTitleColor
        }
    }
}
