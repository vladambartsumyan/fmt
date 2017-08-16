import UIKit
import StoreKit 

extension StageMapVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var FULL_VERSION_ID: String {
        return "team.leko.fmt.fullVersion"
    }
    
    func fetchProduct() {
        let ids: Set<String> = Set.init(arrayLiteral: FULL_VERSION_ID)
        productsRequests = SKProductsRequest(productIdentifiers: ids)
        productsRequests.delegate = self
        productsRequests.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        fullVersion = response.products.count == 1 ? response.products.first : nil
        print(response.products.count)
        print(response.invalidProductIdentifiers)
        print(fullVersion ?? "Продукта нет!")
    }
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            UIAlertView(title: "Error",
                        message: "Purchases are disabled in your device!",
                        delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("DONE")
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                default: break
                }
            }
        }
    }
}
