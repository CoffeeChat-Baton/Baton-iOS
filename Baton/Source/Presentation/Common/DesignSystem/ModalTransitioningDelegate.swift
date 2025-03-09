import UIKit

// 사용방법

//let modalVC = MyModalViewController() // 모달로 보여줄 VC
//let customTransitionDelegate = ModalTransitioningDelegate()
//
//modalVC.modalPresentationStyle = .custom
//modalVC.transitioningDelegate = customTransitionDelegate
//
//present(modalVC, animated: true, completion: nil)


class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class ModalPresentationController: UIPresentationController {
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        // 💡 배경을 화면 전체 크기로 설정 (모달과 완전히 별개로)
        if dimmingView.superview == nil {
            containerView.insertSubview(dimmingView, at: 0)
        }
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0  // 처음에는 투명하게 설정

        // 💡 애니메이션을 통해 서서히 배경이 어두워짐
        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.5  // 부드럽게 어두워짐
            })
        } else {
            dimmingView.alpha = 0.5
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let presentedView = presentedView, let containerView = containerView else { return }

        let modalHeight: CGFloat = containerView.bounds.height // 모달의 높이

        // ✅ 처음에는 화면 아래 배치
        presentedView.frame = CGRect(x: 0,
                                     y: containerView.bounds.height,
                                     width: containerView.bounds.width,
                                     height: modalHeight)

        // ✅ SafeArea 무시하고 완전히 하단에 붙이기
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut) {
            presentedView.frame.origin.y = containerView.bounds.height - modalHeight
        }
    }

}
