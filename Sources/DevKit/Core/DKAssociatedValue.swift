import Foundation
import ObjectiveC.runtime

public func getAssociatedValue<T>(key: String, object: AnyObject) -> T? {
    return (objc_getAssociatedObject(object, key.address) as? DKAssociatedValue)?.value as? T
}

public func set<T>(associatedValue: T?, key: String, object: AnyObject) {
    set(associatedValue: DKAssociatedValue(associatedValue), key: key, object: object)
}

public func set<T : AnyObject>(weakAssociatedValue: T?, key: String, object: AnyObject) {
    set(associatedValue: DKAssociatedValue(weak: weakAssociatedValue), key: key, object: object)
}

private extension String {
    
    var address: UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: abs(hashValue))!
    }
    
}

private func set(associatedValue: DKAssociatedValue, key: String, object: AnyObject) {
    objc_setAssociatedObject(object, key.address, associatedValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

private class DKAssociatedValue {
    
    weak var _weakValue: AnyObject?
    var _value: Any?
    
    var value: Any? {
        return _weakValue ?? _value
    }
    
    init(_ value: Any?) {
        _value = value
    }
    
    init(weak: AnyObject?) {
        _weakValue = weak
    }
    
}
