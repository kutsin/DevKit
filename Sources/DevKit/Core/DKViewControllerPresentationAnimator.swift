#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public final class DKViewControllerPresentationAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    public enum DKCoverDirection {
        case fromTop, fromBottom, fromLeft, fromRight
    }
    
    public enum DKTransitionStyle {
        case cover(DKCoverDirection)
        case crossDissolve
    }
    
    private var transitionStyle: DKTransitionStyle!
    
    public init(transitionStyle: DKTransitionStyle) {
        super.init()
        self.transitionStyle = transitionStyle
    }
    
    public func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        fromViewController.addChild(viewController)

        let sourceView = fromViewController.view
        sourceView.isUserInteractionEnabled = false

        let targetView = viewController.view
        targetView.wantsLayer = true
        targetView.frame = sourceView.bounds
        sourceView.addSubview(targetView)
                
        switch transitionStyle {
        case .cover(let direction):
            let position: CGPoint
            switch direction {
            case .fromTop: position = CGPoint(x: 0.0, y: sourceView.bounds.height)
            case .fromBottom: position = CGPoint(x: 0.0, y: -sourceView.bounds.height)
            case .fromLeft: position = CGPoint(x: -sourceView.bounds.width, y: 0.0)
            case .fromRight: position = CGPoint(x: sourceView.bounds.width, y: 0.0)
            }
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = position
            animation.toValue = CGPoint.zero
            animation.fillMode = .forwards
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.isRemovedOnCompletion = false
            animation.duration = 0.5
            targetView.layer?.add(animation, forKey: "frameAnimation")


            targetView.subviews.forEach { $0.alphaValue = 0.0 }
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                targetView.subviews.forEach { $0.animator().alphaValue = 1.0 }
            }
        case .crossDissolve:
            targetView.alphaValue = 0.0
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                targetView.animator().alphaValue = 1.0
            }
        case .none: break
        }
    }
    
    public func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        fromViewController.view.isUserInteractionEnabled = true

        switch transitionStyle {
        case .cover(_):
            break
        case .crossDissolve:
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                viewController.view.animator().alphaValue = 0.0
            } completionHandler: {
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        case .none: break
        }
    }
}

public extension NSViewControllerPresentationAnimator {
    typealias Animator = DKViewControllerPresentationAnimator
}
#endif
