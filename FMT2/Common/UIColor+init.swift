import UIKit

extension UIColor {
    convenience init(red255 red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 255) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha / 255.0)
    }
}
