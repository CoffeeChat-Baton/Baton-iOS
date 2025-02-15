import UIKit

extension UILabel {
    var pretendardStyle: UIFont.Pretendard? {
        get { return nil }
        set {
            guard let style = newValue else { return }
            self.font = style.font

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = style.leading
            paragraphStyle.maximumLineHeight = style.leading

            let attributedText = NSAttributedString(
                string: self.text ?? "",
                attributes: [
                    .kern: style.tracking,
                    .paragraphStyle: paragraphStyle
                ]
            )

            self.attributedText = attributedText
        }
    }
}
