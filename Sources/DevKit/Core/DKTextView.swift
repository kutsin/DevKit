#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

protocol DKTextViewDelegate: AnyObject {
    func textDidChange(textView: DKTextView)
}

final class DKTextView: NSView {
    
    public var font: NSFont? {
        get { textView.font }
        set { textView.font = newValue }
    }
    
    public var textColor: NSColor? {
        get { textView.textColor }
        set { textView.textColor = newValue }
    }
    
    public var cornerRadius: CGFloat {
        get { layer?.cornerRadius ?? 0.0 }
        set { layer?.cornerRadius = newValue }
    }
    
    public var backgroundColor: NSColor? {
        get { NSColor(cgColor:layer?.backgroundColor ?? .clear) }
        set { layer?.backgroundColor = newValue?.cgColor}
    }
    
    public var attributedPlaceholder: NSAttributedString?
    
    private var scrollView: NSScrollView!
    var textView: NSTextView!
    
    private var shadowLayer: CAShapeLayer!

    weak var delegate: DKTextViewDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    
        scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = false
        scrollView.autoresizingMask = [.width, .height]
        addSubview(scrollView)
        
        textView = NSTextView(frame: NSRect(x: 0.0,
                                            y: 0.0,
                                            width: scrollView.contentSize.width,
                                            height: scrollView.contentSize.height))
        textView.minSize = NSMakeSize(0.0, scrollView.contentSize.height)
        textView.maxSize = NSMakeSize(CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude)
        textView.textContainerInset = NSSize(width: 5.0, height: 10.0)
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isRichText = false
        textView.importsGraphics = false
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.drawsBackground = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = NSMakeSize(scrollView.contentSize.width, CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        addSubview(textView)
    
        scrollView.documentView = textView
        
        shadowLayer = CAShapeLayer()
        //shadowLayer.backgroundColor = NSColor.red.cgColor
        layer?.addSublayer(shadowLayer)
    }

    required init?(coder decoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let mainPath = NSBezierPath(roundedRect: bounds.insetBy(dx: -5.0, dy: -5.0),
                                    xRadius: cornerRadius,
                                    yRadius: cornerRadius)
        let cutPath = NSBezierPath(roundedRect: bounds,
                                   xRadius: cornerRadius,
                                   yRadius: cornerRadius).reversed
        mainPath.append(cutPath)
        shadowLayer.shadowPath = mainPath.cgPath
        shadowLayer.shadowColor = NSColor.black.cgColor
        shadowLayer.shadowOffset = NSSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 2.0
        
        if textView.string.isEmpty {
            let rect = attributedPlaceholder?.boundingRect(with: NSSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude),
                                                           options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin])
            attributedPlaceholder?.draw(at: CGPoint(x: textView.textContainerInset.width + 5.0,
                                                    y: bounds.height - textView.textContainerInset.height - (rect?.height ?? 0.0) + 5))
        }
    }
    
    override func layout() {
        super.layout()
        scrollView.frame = bounds
        shadowLayer.frame = layer!.bounds
        print(layer?.sublayers?.count ?? 0)
    }
}

extension DKTextView {
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        var action: Selector?
        switch event.charactersIgnoringModifiers {
        case "a": action = #selector(NSText.selectAll(_:))
        case "c": action = #selector(NSText.copy(_:))
        case "v": action = #selector(NSText.paste(_:))
        case "x": action = #selector(NSText.cut(_:))
        case "z": action = Selector(("undo:"))
        default: break
        }
        if let action = action {
            return NSApp.sendAction(action, to: nil, from: textView)
        } else {
            return super.performKeyEquivalent(with: event)
        }
    }
}

extension DKTextView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        needsDisplay = true
        delegate?.textDidChange(textView: self)
    }
}
#endif
