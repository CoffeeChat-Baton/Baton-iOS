import UIKit

extension UIView {
    // RootVC 찾기
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    // 다른 영역 터처 시, 키보드 숨김 처리
    func addTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
       
   static func makeContainerView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution = .fill) -> UIStackView {
       let view = UIStackView()
       view.axis = axis
       view.spacing = spacing
       view.distribution = distribution
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }
}
