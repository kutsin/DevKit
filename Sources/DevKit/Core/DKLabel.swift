#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public final class DKLabel: NSControl {
    
    public var edgeInsets: NSEdgeInsets! {
        didSet { needsLayout = true }
    }

    public var backgroundColor: NSColor {
        get {
            guard let backgroundColor = layer?.backgroundColor else { return .clear}
            return NSColor(cgColor: backgroundColor) ?? .clear
        }
        set { layer?.backgroundColor = newValue.cgColor }
    }

    public var textColor: NSColor = .black {
        didSet { textAttributes.updateValue(textColor, forKey: NSAttributedString.Key.foregroundColor) }
    }
    
    public override var font: NSFont? {
        didSet {
            guard let font = font else { return }
            textAttributes.updateValue(font, forKey: NSAttributedString.Key.font)
        }
    }
    
    public var textAttributes: [NSAttributedString.Key : Any] = [:] {
        didSet { setNeedsDisplay() }
    }
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        wantsLayer = true
        edgeInsets = NSEdgeInsets(top: 0.0,
                                  left: 0.0,
                                  bottom: 0.0,
                                  right: 0.0)
    }
    
    private var _boundingRect: NSRect {
        let text = stringValue as NSString
        let rect = text.boundingRect(with: bounds.size,
                                     options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
                                     attributes: textAttributes)
        return rect
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let point: NSPoint
        switch alignment {
        case .left:
            point = NSPoint(x: edgeInsets.left,
                            y: bounds.height / 2.0 - _boundingRect.height / 2.0)
        case .right:
            point = NSPoint(x: bounds.width - edgeInsets.right - _boundingRect.width,
                            y: bounds.height / 2.0 - _boundingRect.height / 2.0)
        case .center:
            fallthrough
        default:
            point = NSPoint(x: bounds.width / 2.0 - _boundingRect.width / 2.0,
                            y: bounds.height / 2.0 - _boundingRect.height / 2.0)
        }
        
        let text = stringValue as NSString
        text.draw(at: point, withAttributes: textAttributes)
    }
    
    public override func sizeToFit() {
        super.sizeToFit()
        frame = NSRect(x: frame.origin.x,
                       y: frame.origin.y,
                       width: _boundingRect.width,
                       height: _boundingRect.height)
    }
}
#endif
