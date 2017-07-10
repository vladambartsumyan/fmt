import UIKit

extension UIViewController {
    
    func layoutAllViews(inView view: UIView) {
        for subview in view.subviews {
            layoutAllViews(inView: subview)
        }
        view.layoutSubviews()
    }
    
}
