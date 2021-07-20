#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSNib {
    
    private enum Error: Swift.Error {
        case unableToFindInstance(Any.Type)
    }
    
    func instantiate(withOwner owner: Any?) -> [Any] {
        var topLevelObjects: NSArray?
        guard instantiate(withOwner: owner,
                          topLevelObjects: &topLevelObjects) else { return [] }
        let result = topLevelObjects as? [Any]
        return result ?? []
    }
    
    func instantiateWithOwner<T>(_ ownerOrNil: Any?) throws -> T {
        let objects = instantiate(withOwner: ownerOrNil)
        for object in objects {
            if let resultObject = object as? T {
                return resultObject
            }
        }
        throw Error.unableToFindInstance(T.self)
    }
}
#endif
