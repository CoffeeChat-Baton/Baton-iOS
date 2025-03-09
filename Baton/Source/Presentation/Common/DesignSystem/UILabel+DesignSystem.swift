import UIKit

extension UILabel {

    static func makeLabel(text: String, textColor: UIColor = .bblack, fontStyle: UIFont.Pretendard = .body1) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.pretendardStyle = fontStyle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTextWithLineSpacing(text, style: fontStyle)
        return label
    }

    var pretendardStyle: UIFont.Pretendard? {
        get { return nil }
        set {
            guard let style = newValue else { return }
            self.font = style.font

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.62  // ✅ 폰트 lineHeight의 162% 적용
            paragraphStyle.alignment = self.textAlignment

            let attributedText = NSAttributedString(
                string: self.text ?? "",
                attributes: [
                    .font: style.font,
                    .foregroundColor: self.textColor ?? UIColor.black,
                    .kern: style.tracking,
                    .paragraphStyle: paragraphStyle
                ]
            )

            self.attributedText = attributedText
            self.numberOfLines = 0
        }
    }


    
    func setTextWithLineSpacing(_ text: String, style: UIFont.Pretendard, lineSpacing: CGFloat = 8.0, lineHeightMultiple: CGFloat = 1.6) {
        let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineSpacing = lineSpacing  // ✅ 줄 간격 설정
        paragraphStyle.lineHeightMultiple = lineHeightMultiple  // ✅ 폰트 크기의 1.6배로 줄 간격 설정
        paragraphStyle.alignment = self.textAlignment  // ✅ 기존 정렬 유지

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: style.font, range: NSMakeRange(0, attributedString.length))  // ✅ Pretendard 폰트 적용
        attributedString.addAttribute(.foregroundColor, value: self.textColor ?? UIColor.black, range: NSMakeRange(0, attributedString.length))  // ✅ 기존 색상 유지
        attributedString.addAttribute(.kern, value: style.tracking, range: NSMakeRange(0, attributedString.length))  // ✅ Pretendard 자간 적용
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
        self.numberOfLines = 0  // ✅ 여러 줄 지원
        self.setNeedsDisplay() // ✅ 강제 UI 업데이트
        self.setNeedsLayout() // ✅ 레이아웃 다시 그리기
    }
}
