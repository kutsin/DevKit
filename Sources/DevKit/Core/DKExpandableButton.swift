#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

final class DKExpandableButton: DKButton {
    
    var maxVisibleCount: Int = 3
    var isExpanded: Bool = false
    
    private var expandedContentView: NSView?
    private var animatableContentView: NSView?
    
    override func commonInit() {
        super.commonInit()
        wantsLayer = true
        layer?.masksToBounds = false
    }
    
    override func layout() {
        super.layout()
        updateLayout()
    }
    
    func updateLayout() {
        expandedContentView?.frame = NSRect(x: 0.0,
                                            y: bounds.height,
                                            width: bounds.width,
                                            height: bounds.height * CGFloat(maxVisibleCount))
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let expandedContentView = expandedContentView else { return }
        topAnimatableConstraint?.constant = isExpanded ? 0 : -expandedContentView.bounds.height
    }
    
    private var topAnimatableConstraint: NSLayoutConstraint?
    
    func set(expanded: Bool, animated: Bool) {
        isExpanded = expanded
        if expanded {
            let expandedContentView = NSView()
            expandedContentView.wantsLayer = true
            expandedContentView.layer?.masksToBounds = true
            expandedContentView.layer?.backgroundColor = NSColor.red.cgColor
            addSubview(expandedContentView)
            self.expandedContentView = expandedContentView
            
            let scrollView = NSScrollView()
            scrollView.backgroundColor = .green
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            expandedContentView.addSubview(scrollView)
            
            scrollView.leadingAnchor.constraint(equalTo: expandedContentView.leadingAnchor).isActive = true
            topAnimatableConstraint = scrollView.topAnchor.constraint(equalTo: expandedContentView.topAnchor, constant: -bounds.height * CGFloat(maxVisibleCount))
            topAnimatableConstraint?.isActive = true
            scrollView.trailingAnchor.constraint(equalTo: expandedContentView.trailingAnchor).isActive = true
            scrollView.heightAnchor.constraint(equalToConstant: bounds.height * CGFloat(maxVisibleCount)).isActive = true

            let animatableContentView = NSView()
            expandedContentView.addSubview(animatableContentView)
            self.animatableContentView = animatableContentView
            
            for _ in 0..<maxVisibleCount {
                let button = DKButton()
                animatableContentView.addSubview(button)
            }
            
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                topAnimatableConstraint?.animator().constant = isExpanded ? 0 : -expandedContentView.bounds.height
            }
        } else {
            expandedContentView?.removeFromSuperview()
            expandedContentView = nil
        }
        needsLayout = true
    }
}

extension DKExpandableButton {
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        set(expanded: !isExpanded, animated: true)
        //guard isEnabled else { return }
        //sendAction(action, to: target)
    }
}
#endif
