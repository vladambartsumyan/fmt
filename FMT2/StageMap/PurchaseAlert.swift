import UIKit

class PurchaseAlert: UIViewController {
    
    @IBOutlet weak var buyButton: TextButton!
    @IBOutlet weak var restoreButton: TextButton!
    @IBOutlet weak var crossButton: TopButton!
    
    var buyAction = {}
    var restoreAction = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyButton.setTitle(titleText: "Купить")
        restoreButton.setTitle(titleText: "Восстановить покупку")
        crossButton.setIcon(withName: "cross")
        restoreButton.setBodyColor(bodyColor: .orange)
    }
    
    @IBAction func buyTap(_ sender: TextButton) {
        self.dismiss(animated: true, completion: nil)
        buyAction()
    }
    
    @IBAction func restoreTap(_ sender: TextButton) {
        self.dismiss(animated: true, completion: nil)
        restoreAction()
    }
    
    @IBAction func crossTap(_ sender: TopButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
