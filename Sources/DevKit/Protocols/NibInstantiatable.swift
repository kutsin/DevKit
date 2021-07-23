#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public protocol NibInstantiatable: AnyObject {
    static var nib: NSNib { get }
    static func instantiateFromNib() -> Self
}

public extension NibInstantiatable {
    static var nib: NSNib {
        return NSNib(nibNamed: String(describing: self), bundle: Bundle(for: self))!
    }
    static func instantiateFromNib() -> Self {
        return try! nib.instantiateWithOwner(nil)
    }
}
#endif

#if canImport(UIKit)
import UIKit

public protocol NibInstantiatable: AnyObject {
    static var nib: UINib { get }
}

public extension NibInstantiatable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

public extension NibInstantiatable where Self: UIView {
    static func instantiateFromNib() -> Self {
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
}
#endif
