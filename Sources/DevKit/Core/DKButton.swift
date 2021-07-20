#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class DKButton: NSControl {
    
    public var colors: [NSColor]? {
        didSet {
            if let colors = colors, colors.count == 1 {
                backgroundLayer.backgroundColor = colors.first?.cgColor
            } else {
                backgroundLayer.colors = colors?.compactMap { $0.cgColor }
            }
            needsLayout = true
        }
    }
    
    public var highlightedColor = NSColor.white.withAlphaComponent(0.5)
    public var focusedColor = NSColor.clear
    
    public var canBecomeHighlighted = false
    public var canBecomeFocused = false

    public var contentView: NSView!
    public var titleLabel: NSTextField!
    public var detailLabel: NSTextField!
    
    public var backgroundLayer: CAGradientLayer!
    public var highlightableLayer: CALayer!
    
    public var edgeInsets = NSEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    public var textAlignment: NSTextAlignment = .center
    public var elementOffset: CGFloat = 0.0
    public var imageView: NSImageView!
    
    public var cornerRadius: CGFloat? {
        get { contentView.layer?.cornerRadius }
        set { contentView.layer?.cornerRadius = newValue ?? 0.0 }
    }
        
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        contentView = NSView()
        contentView.wantsLayer = true
        addSubview(contentView)
        
        backgroundLayer = CAGradientLayer()
        contentView.layer?.addSublayer(backgroundLayer)
        
        highlightableLayer = CALayer()
        contentView.layer?.addSublayer(highlightableLayer)
        
        titleLabel = NSTextField()
        titleLabel.isSelectable = false
        titleLabel.textColor = .white
        titleLabel.drawsBackground = false
        titleLabel.isEditable = false
        titleLabel.isBezeled = false
        titleLabel.alignment = .center
        contentView.addSubview(titleLabel)
        
        detailLabel = NSTextField()
        detailLabel.isSelectable = false
        detailLabel.textColor = .gray
        detailLabel.drawsBackground = false
        detailLabel.isEditable = false
        detailLabel.isBezeled = false
        detailLabel.alignment = .center
        contentView.addSubview(detailLabel)
        
        isEnabled = true
        
        imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        contentView.addSubview(imageView)
    }
    
    open override func layout() {
        super.layout()
        titleLabel.sizeToFit()
        detailLabel.sizeToFit()
        
        contentView.frame = bounds
        backgroundLayer.frame = contentView.layer!.bounds
        highlightableLayer.frame = contentView.layer!.bounds
        
        switch textAlignment {
        case .left:
            titleLabel.frame.origin.x = edgeInsets.left
            detailLabel.frame.origin.x = edgeInsets.left
        case .right:
            titleLabel.frame.origin.x = contentView.bounds.width - edgeInsets.right - titleLabel.bounds.width
            detailLabel.frame.origin.x = contentView.bounds.width - edgeInsets.right - detailLabel.bounds.width
        case .center:
            titleLabel.frame.origin.x = contentView.bounds.width / 2.0 - titleLabel.bounds.width / 2.0
            detailLabel.frame.origin.x = contentView.bounds.width / 2.0 - detailLabel.bounds.width / 2.0
        default: break
        }
        
        detailLabel.isHidden = detailLabel.stringValue.isEmpty
        if detailLabel.stringValue.isEmpty {
            titleLabel.frame.origin.y = contentView.bounds.height / 2.0 - titleLabel.bounds.height / 2.0 + 1.0
        } else {
            titleLabel.frame.origin.y = (contentView.bounds.height / 2.0 + titleLabel.bounds.height / 2.0) - detailLabel.bounds.height / 2.0
            titleLabel.frame.origin.y = titleLabel.frame.origin.y - 6.0
            detailLabel.frame.origin.y = titleLabel.frame.origin.y - detailLabel.bounds.height + 3.0
        }
        
        imageView.frame = CGRect(x: edgeInsets.right,
                                 y: edgeInsets.top,
                                 width: contentView.bounds.width - edgeInsets.right - edgeInsets.left,
                                 height: contentView.bounds.height - edgeInsets.top - edgeInsets.bottom)
        
        titleLabel.frame.origin.y = titleLabel.frame.origin.y.rounded()
        detailLabel.frame.origin.y = detailLabel.frame.origin.y.rounded()
    }
    
    open var isSelected: Bool = false
    
    private var _isEnabled: Bool = true
    public override var isEnabled: Bool {
        get { _isEnabled }
        set { set(enabled: newValue, animated: false) }
    }
    public func set(enabled: Bool, animated: Bool) {
        _isEnabled = enabled
        set(highlighted: false, animated: animated)
        let alpha: CGFloat = enabled ? 1.0 : 0.5
        if animated {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 1
                animator().alphaValue = alpha
                titleLabel.animator().alphaValue = alpha
                detailLabel.animator().alphaValue = alpha
            }
        } else {
            alphaValue = alpha
            titleLabel.alphaValue = alpha
            detailLabel.alphaValue = alpha
        }
    }
    
    func set(highlighted: Bool, animated: Bool) {
        highlightableLayer.backgroundColor = highlighted ? highlightedColor.cgColor : NSColor.clear.cgColor
    }
    
    func set(focused: Bool, animated: Bool) {
        highlightableLayer.backgroundColor = focused ? focusedColor.cgColor : NSColor.clear.cgColor
    }

    var trackingArea: NSTrackingArea?
    
    public override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if trackingArea != nil {
            removeTrackingArea(trackingArea!)
        }
        trackingArea = NSTrackingArea(rect: bounds,
                                      options: [.mouseEnteredAndExited, .activeInKeyWindow],
                                      owner: self,
                                      userInfo: nil)
        addTrackingArea(trackingArea!)
    }
    
}

extension DKButton {
    public override func mouseUp(with event: NSEvent) {
        if canBecomeHighlighted {
            set(highlighted: false, animated: true)
        }
        let containsPoint = bounds.contains(convert(event.locationInWindow, from: nil))
        guard isEnabled, containsPoint else { return }
        isSelected.toggle()
        sendAction(action, to: target)
    }
    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        guard isEnabled && canBecomeHighlighted else { return }
        set(highlighted: true, animated: true)
    }
    public override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        guard isEnabled && canBecomeFocused else { return }
        set(focused: false, animated: true)
    }
    public override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        guard isEnabled && canBecomeFocused else { return }
        set(focused: true, animated: true)
    }
}
#endif
