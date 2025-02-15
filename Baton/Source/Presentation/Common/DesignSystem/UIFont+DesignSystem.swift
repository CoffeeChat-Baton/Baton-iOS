import UIKit

enum PretendardFontName: String {
    case semibold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
}

extension UIFont {
    enum Pretendard {
        case head1, title1, title2, body1, body2, body3, body4, body5, caption1, caption2

        var name: String {
            switch self {
            case .head1, .title1, .body1, .body3, .caption1:
                return PretendardFontName.semibold.rawValue
            case .title2, .body2, .body4, .caption2:
                return PretendardFontName.medium.rawValue
            case .body5:
                return PretendardFontName.regular.rawValue
            }
        }

        var size: CGFloat {
            switch self {
            case .head1: return 22
            case .title1, .title2: return 18
            case .body1, .body2: return 16
            case .body3, .body4, .body5: return 14
            case .caption1, .caption2: return 12
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
            if let customFont = UIFont(name: self.name, size: self.size) {
                return customFont
            } else {
                return UIFont.systemFont(ofSize: self.size, weight: .regular)
            }
        }
    }
}
