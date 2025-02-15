import UIKit

extension UIButton {
    var pretendardStyle: UIFont.Pretendard? {
        get { return nil }
        set {
            guard let style = newValue else { return }
            self.titleLabel?.font = style.font

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = style.leading
            paragraphStyle.maximumLineHeight = style.leading

            let attributedText = NSAttributedString(
                string: self.title(for: .normal) ?? "",
                attributes: [
                    .kern: style.tracking,
                    .paragraphStyle: paragraphStyle 
                ]
            )

            self.setAttributedTitle(attributedText, for: .normal)
        }
    }
}
