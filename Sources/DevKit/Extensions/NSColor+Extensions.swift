#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSColor {
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
#endif
