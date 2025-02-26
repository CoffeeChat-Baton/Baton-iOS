import UIKit

struct BatonNavigationButton {
    static func backButton(target: Any, action: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: target,
            action: action
        )
        button.tintColor = .bblack
        return button
    }
}
