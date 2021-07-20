#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public final class DKActivityIndicatorViewController<ActivityIndicatorView: NSView>: NSViewController {
    
    public var indicatorView: ActivityIndicatorView!

    private var contentView: NSView!
    private var effectView: NSView!
    private var titleLabel: NSTextField!
    
    public init(configuration: () -> ActivityIndicatorView) {
        super.init(nibName: nil, bundle: nil)
        indicatorView = configuration()
        
        effectView = NSView()
        effectView.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)
        effectView.wantsLayer = true
        effectView.layer?.cornerRadius = 10.0
        effectView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.5).cgColor
        
        titleLabel = NSTextField()
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.isSelectable = false
        titleLabel.isEnabled = false
        titleLabel.drawsBackground = false
        titleLabel.focusRingType = .none
        titleLabel.textColor = NSColor.white.withAlphaComponent(0.75)
        titleLabel.stringValue = "Processing..."
        titleLabel.sizeToFit()
        titleLabel.alignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = NSView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
            
        contentView = NSView()
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.75).cgColor
        view.addSubview(contentView)
        
        contentView.addSubview(effectView)
        contentView.addSubview(indicatorView)
        contentView.addSubview(titleLabel)
    }
    
    public override func viewWillLayout() {
        super.viewWillLayout()
        contentView.frame = view.bounds
        effectView.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        indicatorView.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: contentView.bounds.midX,
                                    y: effectView.frame.origin.y - effectView.bounds.height - 5.0)

    }
}
#endif
