import UIKit

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
        guard let presentedView = presentedView else { return }

        let finalY = containerView!.bounds.height * 0.4  // 원하는 위치
        presentedView.frame = CGRect(x: 0,
                                     y: containerView!.bounds.height,  // 💡 처음엔 화면 아래쪽에 배치
                                     width: containerView!.bounds.width,
                                     height: containerView!.bounds.height * 0.6)

        // 💡 부드러운 스프링 애니메이션으로 자연스럽게 올라오도록 함
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseOut) {
            presentedView.frame.origin.y = finalY
        }
    }
//
//    override func dismissalTransitionWillBegin() {
//        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
//            self.dimmingView.alpha = 0
//        }) { _ in
//            self.dimmingView.removeFromSuperview()
//        }
//    }
    
//    override func containerViewWillLayoutSubviews() {
//        guard let presentedView = presentedView else { return }
//        presentedView.frame = CGRect(x: 0,
//                                     y: containerView!.bounds.height * 0.4, // 💡 원하는 위치 조절
//                                     width: containerView!.bounds.width,
//                                     height: containerView!.bounds.height * 0.6)
//        presentedView.layer.cornerRadius = 16
//        presentedView.clipsToBounds = true
//    }
}
