import UIKit

class AlertMaker: NSObject {
    
    static func newGameAlert(withYesAction yesAction: (() -> ())?) -> UIAlertController {
        
        let title = NSLocalizedString("Alert.newGame.title", comment: "")
        let message = NSLocalizedString("Alert.newGame.message", comment: "")
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let yesTitle = NSLocalizedString("Alert.newGame.yesTitle", comment: "") 
        alert.addAction(
            UIAlertAction.init(title: yesTitle, style: .default, handler: { (action) in
                yesAction?()
            })
        )
        
        let noTitle = NSLocalizedString("Alert.newGame.noTitle", comment: "") 
        alert.addAction(
            UIAlertAction.init(title: noTitle, style: .cancel, handler: nil)
        )
        
        return alert
    }
}
