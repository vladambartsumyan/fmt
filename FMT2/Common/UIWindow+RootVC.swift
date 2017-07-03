import UIKit

extension AppDelegate {
    static var current: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
