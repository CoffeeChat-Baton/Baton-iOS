import UIKit

class SelectionTitleLabel: UILabel {
    
    init(title: String, style: UIFont.Pretendard = .body4, color: UIColor = .black) {
        super.init(frame: .zero)
        self.text = title
        self.pretendardStyle = style
        self.textColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
