import UIKit

class SelectionButton: UIButton {
    var mode: Mode = .selection
    
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
            case .selection: return .bblack
            case .uploadFile: return .gray4
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.6 : 1.0
            }
        }
    }
    
    init(mode: Mode = .selection) {
        self.mode = mode 
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        titleLabel?.pretendardStyle = .body4
        setTitleColor(mode.titleColor, for: .normal)
        contentHorizontalAlignment = .left
        backgroundColor = mode.backgroundColor
        layer.cornerRadius = CornerRadius.button.value
        layer.borderWidth = 1

        switch mode {
        case .selection:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            layer.borderColor = UIColor(resource: .gray3).cgColor
            
            let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrowImageView.tintColor = .gray
            arrowImageView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(arrowImageView)
            
            NSLayoutConstraint.activate([
                arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        case .uploadFile:
            let uploadFileImageView = UIImageView(image: UIImage(resource: .uploadFile))
            uploadFileImageView.tintColor = .gray4
            uploadFileImageView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(uploadFileImageView)
            
            NSLayoutConstraint.activate([
                uploadFileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                uploadFileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
            ])
        }
       
    }
}
