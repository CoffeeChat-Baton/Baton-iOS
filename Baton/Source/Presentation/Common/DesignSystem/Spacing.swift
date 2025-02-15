import UIKit

enum Spacing {
    case extraSmall, small, medium, large, extraLarge

    var value: CGFloat {
        switch self {
        case .extraSmall: return 4
        case .small: return 8
        case .medium: return 16
        case .large: return 22
        case .extraLarge: return 32
        }
    }
}
