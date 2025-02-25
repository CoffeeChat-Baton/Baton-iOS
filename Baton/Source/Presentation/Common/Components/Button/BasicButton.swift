import UIKit

enum BasicButtonStatus {
    case disabled
    case enabled
}

final class BasicButton: UIButton {
    
    // 상태 저장 및 UI 업데이트
    var status: BasicButtonStatus = .enabled {
        didSet {
            updateUI()
        }
    }
    
    // 버튼 색상 설정
    private let disabledColor: UIColor = UIColor(resource: .gray3)
    private let enabledColor: UIColor = UIColor(resource: .main)
    
    init(title: String, status: BasicButtonStatus) {
        super.init(frame: .zero)
        self.status = status
        configureButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 버튼 UI 초기 설정
    private func configureButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.pretendardStyle = .body1
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        updateUI()
    }
    
    // 버튼 상태 변경 시 UI 업데이트
    private func updateUI() {
        backgroundColor = (status == .enabled) ? enabledColor : disabledColor
        isEnabled = (status == .enabled)
        alpha = (status == .enabled) ? 1.0 : 0.5
    }
}
