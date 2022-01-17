import SwiftUI
import SwiftyStoreKit

@main
struct BigLapTimerApp: App {
    
    init() {
            UITableView.appearance().backgroundColor = .clear
        }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  // 追加する
    
    var body: some Scene {
        WindowGroup {
            ContentView( total: [], laptime: [], lapNo: [], lapn: 1, nowTime: 0)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            for product in products {
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {

                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "receiptData")
                    defaults.synchronize()

                    if product.needsFinishTransaction {

                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    print("purchased: \(product)")
                }
            }
        }
        
        return true
    }
    // 必要に応じて処理を追加
}
