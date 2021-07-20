#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public final class DKAnimatedPathView: NSView {
    
    public var tintColor: NSColor = .white {
        didSet {
            animatedLayer.strokeColor = tintColor.cgColor
            needsLayout = true
        }
    }
    
    private var animatedLayer: CAShapeLayer!
    
    private var sourcePath: CGPath!
    private var targetPath: CGPath!
    
    private enum PathState {
        case source, target
    }
    
    private var pathState: PathState = .source

    public init(sourcePath: CGPath, targetPath: CGPath) {
        super.init(frame: .zero)
        self.sourcePath = sourcePath
        self.targetPath = targetPath
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        wantsLayer = true
        layer?.masksToBounds = false

        animatedLayer = CAShapeLayer()
        animatedLayer.strokeColor = tintColor.cgColor
        animatedLayer.lineWidth = 2.0
        animatedLayer.lineCap = .round
        animatedLayer.masksToBounds = false
        layer?.addSublayer(animatedLayer)
    }

    public override func layout() {
        super.layout()
        sourcePath = sourcePath.scaledToFit(size: bounds.size)
        targetPath = targetPath.scaledToFit(size: bounds.size)
        
        let currentPath = pathState == .source ? sourcePath : targetPath
        animatedLayer.frame = bounds
        animatedLayer.path = currentPath
    }
    
    public func startAnimating() {
        animate(forward: true)
    }
    
    public func stopAnimating() {
        animate(forward: false)
    }
    
    public func animate(forward: Bool) {
        if (forward && pathState == .target) ||
            (!forward && pathState == .source) {
            return
        }

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = animatedLayer.presentation()?.path
        animation.toValue = forward ? targetPath : sourcePath
        animation.duration = 0.15
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animatedLayer.add(animation, forKey: "pathAnimation")
        
        pathState = forward ? .target : .source
    }
}
#endif
