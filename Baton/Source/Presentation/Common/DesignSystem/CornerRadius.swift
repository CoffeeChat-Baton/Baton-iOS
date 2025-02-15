import UIKit

enum CornerRadius {
    case button

    var value: CGFloat {
        switch self {
        case .button: return 12
        }
    }
}
