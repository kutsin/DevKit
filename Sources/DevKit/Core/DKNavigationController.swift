#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSViewController {
    var navigationController: DKNavigationController? {
        return _navigationController(for: self)
    }
    
    private func _navigationController(for controller: NSViewController?) -> DKNavigationController? {
        guard let controller = controller else { return nil }
        if let navigationController = controller as? DKNavigationController {
            return navigationController
        }
        return _navigationController(for: controller.parent)
    }
}

public final class DKNavigationController: NSViewController {
    public var viewControllers: [NSViewController] = []
    
    public init(rootViewController: NSViewController) {
        super.init(nibName: nil, bundle: .main)
        viewControllers.append(rootViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = NSView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewController = viewControllers.last,
              viewControllers.count == 1 else { fatalError("Something went wrong") }
        addChild(viewController)
        view.addSubview(viewController.view)
    }
    
    public func pushViewController(_ viewController: NSViewController,
                                   animated: Bool,
                                   options: TransitionOptions = [.slideLeft]) {
        guard let currentViewController = viewControllers.last else { fatalError("Something went wrong") }
        currentViewController.view.isUserInteractionEnabled = false
        
        addChild(viewController)
        transition(from: currentViewController,
                   to: viewController,
                   options: animated ? options : []) {
            self.viewControllers.append(viewController)
        }
    }
    
    public override func viewDidLayout() {
        super.viewDidLayout()
        viewControllers.forEach { $0.view.frame = view.bounds }
    }
    
    @discardableResult
    public func popViewController(animated: Bool,
                                  options: TransitionOptions = [.slideRight]) -> NSViewController? {
        guard viewControllers.count > 1 else { return nil }
        let previosController = viewControllers[viewControllers.count - 2]
        return popToViewController(previosController, animated: animated, options: options)?.first
    }
    
    @discardableResult
    public func popToViewController(_ viewController: NSViewController,
                                    animated: Bool,
                                    options: TransitionOptions = [.slideRight]) -> [NSViewController]? {
        guard let index = viewControllers.firstIndex(of: viewController),
              let last = viewControllers.last,
              viewControllers.count > 1 else { return nil }
        
        let fromIndex = index + 1
        let toPop = viewControllers[fromIndex...]
        
        viewController.view.isUserInteractionEnabled = true
        
        transition(from: last,
                   to: viewController,
                   options: animated ? options : []) {
            for poped in toPop {
                poped.view.removeFromSuperview()
                poped.removeFromParent()
            }
            self.viewControllers.removeSubrange(fromIndex...)
        }
        return Array(toPop)
    }

    @discardableResult
    public func popToRootViewController(animated: Bool,
                                        options: TransitionOptions = [.slideRight]) -> [NSViewController]? {
        guard let first = viewControllers.first else { return nil }
        return popToViewController(first, animated: animated, options: options)
    }

    
    public var topViewController: NSViewController? {
        return viewControllers.last
    }

    public var visibleViewController: NSViewController? {
        return viewControllers.last
    }

    //public func setViewControllers(_ viewControllers: [NSViewController], animated: Bool) {}

}
#endif
