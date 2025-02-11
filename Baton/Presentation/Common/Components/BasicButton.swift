import UIKit

enum BasicButtonStatus {
    case disabled
    case enabled
}

final class BasicButton: UIButton {
    var staus: BasicButtonStatus = .enabled {
        didSet{
            self.backgroundColor = getBackgroundColor(type: staus)
        }
    }
    
    // 버튼 구성시 필요한 색상
    let disabledColor: UIColor = UIColor(resource: .gray3)
    let enabledColor: UIColor = UIColor(resource: .main)
    
    init(title: String, status: BasicButtonStatus) {
        super.init(frame: .zero)
        self.staus = status
        configureButton(title: title)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(title: String) {
        setTitle(title, for: .normal)
        backgroundColor = getBackgroundColor(type: self.staus)
        titleLabel?.textColor = .white
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = true
        isEnabled = true // 터치 가능
    }
    
    private func getBackgroundColor(type: BasicButtonStatus) -> UIColor {
        switch type {
        case .disabled:
            return disabledColor
        case .enabled:
            return enabledColor
        }
    }
    
}
