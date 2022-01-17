import SwiftUI
import SwiftyStoreKit


struct SSecondView: View {
    
    @State var restoreAlert : Bool = false

    var body: some View {
        HStack{
            Button(action: {
                SwiftyStoreKit.purchaseProduct("lap123", quantity: 1, atomically: false) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        print("Purchase Success: \(product.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
                SwiftyStoreKit.retrieveProductsInfo(["lap123"]) { result in
                    if let product = result.retrievedProducts.first {
                        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                            // handle result (same as above)
                        }
                    }
                }
                
                
                
            }){
                TextView(label : "購入")
            }
            Button(action: {
                
                SwiftyStoreKit.restorePurchases(atomically: false) { results in
                    if results.restoreFailedPurchases.count > 0 {
                        print("Restore Failed: \(results.restoreFailedPurchases)")
                    }
                    else if results.restoredPurchases.count > 0 {
                        for purchase in results.restoredPurchases {
                            // fetch content from your server, then:
                            if purchase.needsFinishTransaction {
                                SwiftyStoreKit.finishTransaction(purchase.transaction)
                            }
                        }
                        print("Restore Success: \(results.restoredPurchases)")
                    }
                    else {
                        self.restoreAlert = true          // ②タップされたら表示フラグをtrueにする
                        print("Nothing to Restore")
                    }
                }
            }){
                TextView(label : "復元")
            }.alert(isPresented: $restoreAlert){
                Alert(title: Text("購入履歴はありません。"))
            }
        }
        
    }
}
