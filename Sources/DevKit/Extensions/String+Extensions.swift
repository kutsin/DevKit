import Foundation
import CoreGraphics

extension String {
    public func width(height: CGFloat, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingRect = (self as NSString).boundingRect(with: size,
                                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                           attributes: attributes,
                                                           context: nil)
        return boundingRect.width
    }
    
    public func height(width: CGFloat, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingRect = (self as NSString).boundingRect(with: size,
                                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                           attributes: attributes,
                                                           context: nil)
        return boundingRect.height
    }
}
