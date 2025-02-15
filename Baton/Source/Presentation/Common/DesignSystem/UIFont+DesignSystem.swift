import UIKit

extension UIFont {
    enum Pretendard {
        case title
        case headline
        case body
        case caption
        case button

        var name: String {
            switch self {
            case .title: return "Pretendard-Bold"
            case .headline: return "Pretendard-SemiBold"
            case .body: return "Pretendard-Medium"
            case .caption: return "Pretendard-Regular"
            case .button: return "Pretendard-Bold"
            }
        }

        var size: CGFloat {
            switch self {
            case .title: return 24
            case .headline: return 20
            case .body: return 16
            case .caption: return 12
            case .button: return 14
            }
        }

        var weight: UIFont.Weight {
            switch self {
            case .title: return .bold
            case .headline: return .semibold
            case .body: return .medium
            case .caption: return .regular
            case .button: return .bold
            }
        }

        /// **Tracking(-2%) 적용**
        var tracking: CGFloat {
            return -(size * 0.02)
        }

        /// **Leading(160%) 적용**
        var leading: CGFloat {
            return size * 1.6
        }

        /// **UIFont 생성**
        var font: UIFont {
            return UIFont(name: self.name, size: self.size) ?? UIFont.systemFont(ofSize: self.size, weight: self.weight)
        }
    }
}
