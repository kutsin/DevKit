#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import CoreGraphics
import Foundation
import AppKit

public extension CGPath {
    
    func scaledToFit(size: CGSize) -> CGPath {
        let pathAspectRatio = boundingBox.width / boundingBox.height
        let sizeAspectRatio = size.width / size.height

        let scaleFactor = pathAspectRatio > sizeAspectRatio ?
            size.width / boundingBox.width : size.height / boundingBox.height
        
        var transform = CGAffineTransform.identity
            .scaledBy(x: scaleFactor, y: scaleFactor)
            //.translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)
        
//        let scaledSize = boundingBox.size.applying(CGAffineTransform (scaleX: scaleFactor, y: scaleFactor))
//        let centerOffset = CGSize(width: (size.width - scaledSize.width ) / scaleFactor * 2.0,
//                                  height: (size.height - scaledSize.height) /  scaleFactor * 2.0)
//        transform = transform.translatedBy(x: centerOffset.width, y: centerOffset.height)

        return copy(using: &transform)!
    }
    


    
    static func rectPath(for frame: CGRect, cornerRadius: CGFloat = 0.0) -> CGPath {
        return NSBezierPath(roundedRect: frame.insetBy(dx: cornerRadius / 2.0, dy: cornerRadius / 2.0),
                            xRadius: cornerRadius,
                            yRadius: cornerRadius).cgPath
    }
    
//    static func rectPath(for frame: CGRect, cornerRadius: CGFloat = 0.0) -> CGPath {
//        let frame = frame.insetBy(dx: cornerRadius / 2.0, dy: cornerRadius / 2.0)
//        let borderOffset = cornerRadius + cornerRadius / 2.0
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: frame.origin.x, y: frame.midY))
//        path.addLine(to: CGPoint(x: frame.origin.x, y: frame.height - borderOffset))
//        path.addArc(center: CGPoint(x: frame.origin.x + borderOffset, y: frame.height - borderOffset),
//                    radius: cornerRadius,
//                    startAngle: -CGFloat.pi,
//                    endAngle: CGFloat.pi / 2.0,
//                    clockwise: true)
//        path.addLine(to: CGPoint(x: frame.width - cornerRadius, y: frame.height))
//        path.addArc(center: CGPoint(x: frame.width - cornerRadius, y: frame.height - cornerRadius),
//                    radius: cornerRadius,
//                    startAngle: CGFloat.pi / 2.0,
//                    endAngle: 0.0,
//                    clockwise: true)
//        path.addLine(to: CGPoint(x: frame.width, y: cornerRadius))
//        path.addArc(center: CGPoint(x: frame.width - cornerRadius, y: cornerRadius),
//                    radius: cornerRadius,
//                    startAngle: 0.0,
//                    endAngle: 3.0 * CGFloat.pi / 2.0,
//                    clockwise: true)
//        path.addLine(to: CGPoint(x: frame.origin.x + cornerRadius, y: 0.0))
//        path.addArc(center: CGPoint(x: frame.origin.x + cornerRadius, y: cornerRadius),
//                    radius: cornerRadius,
//                    startAngle: 3.0 * CGFloat.pi / 2.0,
//                    endAngle: CGFloat.pi,
//                    clockwise: true)
//        path.addLine(to: CGPoint(x: frame.origin.x, y: frame.midY))
//        return path
//    }
}
#endif
