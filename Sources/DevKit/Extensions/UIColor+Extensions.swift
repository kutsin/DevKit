#if canImport(UIKit)
import UIKit

public extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    static var random: UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(255)),
                       g: CGFloat(arc4random_uniform(255)),
                       b: CGFloat(arc4random_uniform(255)),
                       a: 1.0)
    }
}
#endif
