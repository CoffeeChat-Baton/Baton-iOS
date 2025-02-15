import UIKit

enum ButtonSize {
    case small, medium, large

    var height: CGFloat {
        switch self {
        case .small: return 44
        case .medium: return 48
        case .large: return 52
        }
    }
}
