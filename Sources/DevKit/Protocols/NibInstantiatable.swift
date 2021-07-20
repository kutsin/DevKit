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
