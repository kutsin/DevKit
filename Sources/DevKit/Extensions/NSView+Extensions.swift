#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSView {
    
    var titleBarHeight: CGFloat {
        let height = window?.contentLayoutRect.height ?? 0.0
        return frame.height - height
    }
    
    var aplpa: CGFloat {
        get { alphaValue }
        set { alphaValue = newValue }
    }
        
    var isUserInteractionEnabled: Bool {
        get {
            if let control = self as? NSControl {
                return control.isEnabled
            } else {
                return !subviews.compactMap { $0.isUserInteractionEnabled }.contains(false)
            }
        }
        set {
            window?.makeFirstResponder(nil)
            focusRingType = .none
            (self as? NSControl)?.isEnabled = newValue

            subviews.forEach { $0.isUserInteractionEnabled = newValue }
        }
    }
    
    var center: CGPoint {
        get { CGPoint(x: frame.midX, y: frame.midY) }
        set {
            //guard let superview = superview else { return }
            frame = CGRect(x: newValue.x - bounds.midX,
                           y: newValue.y - bounds.midY,
                           width: bounds.width,
                           height: bounds.width) }
    }
    
    var snapshot: NSImage? {
        guard let imageRep = bitmapImageRepForCachingDisplay(in: bounds) else { return nil }
        cacheDisplay(in: bounds, to: imageRep)
        let image = NSImage()
        image.addRepresentation(imageRep)
        return image
    }
}
#endif
