import UIKit
import StoreKit 

extension StageMapVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var FULL_VERSION_ID: String {
        return "leko.team.fmt.fullVersion"
    }
    
    func buyProduct() {
        let ids: Set<String> = Set(arrayLiteral: FULL_VERSION_ID)
        productsRequests = SKProductsRequest(productIdentifiers: ids)
        productsRequests.delegate = self
        productsRequests.start()
    }
    
    func restoreProduct() {
        if self.canMakePurchases() {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            showAlert(withAlertKey: "StageMap.alert.cantMakePurchase")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        fullVersion = response.products.count == 1 ? response.products.first : nil
        if fullVersion != nil {
            purchaseMyProduct(product: fullVersion!)
        } else {
            showAlert(withAlertKey: "StageMap.alert.productNotFound")
        }
    }
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            showAlert(withAlertKey: "StageMap.alert.cantMakePurchase")
        }
    }
    
    func showAlert(withAlertKey alertKey: String) {
        UIAlertView(title: NSLocalizedString(alertKey + ".title", comment: "") ,
                    message: NSLocalizedString(alertKey + ".message", comment: ""),
                    delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    UserDefaults.standard.set(true, forKey: UserDefaultsKey.isFullVersion.rawValue)
                    isFullVersion = true
                    updateButtons()
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    UserDefaults.standard.set(true, forKey: UserDefaultsKey.isFullVersion.rawValue)
                    isFullVersion = true
                    updateButtons()
                    break
                default: break
                }
            }
        }
    }
    
    func restoreAlert() {
        let alert = UIAlertController(
            title: "Покупка успешно восстановлена", 
            message: "Полная версия приложения была восстановлена бесплатно", 
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
