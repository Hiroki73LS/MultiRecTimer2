import SwiftUI
import SwiftyStoreKit

enum AlertType {
    case first
    case second
}

struct SecondView: View {
    
    @State var restoreAlert : Bool = false
    @State var priceLabel : String = "購入する"
    @Binding var lap234Purchase : String
    @Environment(\.presentationMode) var presentationMode
    @State var isPresentedProgressView = false
    @State var Buttondisable : Bool = false
    @State var whichAlert : AlertType = AlertType.first

    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            
            VStack{
                Spacer().frame(height: 50)
                Text("App内課金オプション").font(.largeTitle)
                VStack(alignment: .leading){
                    Text("【下記の機能が追加されます】").bold()
                    Spacer().frame(height: 10)
                    VStack(alignment: .leading){
                        Text(" １．広告非表示")
                        Text(" ２．ラップタイム記録数の上限を")
                        Text("　 　現在の３０回から９９回にする。")
                        Text(" ３．履歴保存の上限数を")
                        Text("　 　現在の２０回から５０回にする。")
                    }.frame(height: 150)
                    .border(Color.black, width: 2)
                    Spacer().frame(height: 15)
                    Text("このApp内課金オプションは、")
                    Text("非消耗型オプションです。")
                    Spacer().frame(height: 15)
                    Text("アプリを再インストールした場合は、")
                    Text("下記の「復元する」から購入履歴の")
                    Text("復元をしてください。")
                }.font(.title2)
                    .frame(width: 370, height: 350)
                    Spacer().frame(height: 20)
                Text("(JPY 120円)").font(.title3)
                
                Button(action: {
                    manageProgress()
                    print("Storkit読み込み")
                    
                    SwiftyStoreKit.purchaseProduct("lap50", quantity: 1, atomically: true) { result in
                        print("Storkit読み込み2\(result)")
                            switch result {
                        case .success(let purchase):
                            print("Purchase Success: \(purchase.productId)")
                            
                            let defaults = UserDefaults.standard
                            defaults.set("true", forKey: "lap234")
                            defaults.set(true, forKey: "Buttondisable")
                            defaults.set("購入済み", forKey: "Buttonlabel")

                            Buttondisable = true
                            lap234Purchase = "true"
                            self.presentationMode.wrappedValue.dismiss()
                            // 購入後の処理はここに記述しよう。例えばUser Default などのフラグを変更するとか。
                            
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
                    print("Storkit読み込み3")
                    
                }){
                    if Buttondisable == false {
                        TextView2(label : "\(priceLabel)")
                    } else {
                        TextView3(label : "\(priceLabel)")
                    }
                }.disabled(Buttondisable)
                .buttonStyle(MyButtonStyle2())
                Spacer().frame(height: 25)
                
                Button(action: {
                    manageProgress2()

                    SwiftyStoreKit.restorePurchases(atomically: true) { results in
                        if results.restoreFailedPurchases.count > 0 {
                            print("Restore Failed: \(results.restoreFailedPurchases)")
                        }
                        else if results.restoredPurchases.count > 0 {
                            for product in results.restoredPurchases {
                                if product.needsFinishTransaction {
                                    SwiftyStoreKit.finishTransaction(product.transaction)
                                    print("finishTransaction")
                                }
                                if results.restoredPurchases.count > 0 {
                                    print("Restore Success: \(results.restoredPurchases)")
                                    print("product.productId: \(product.productId)")
                                    lap234Purchase = "true"
                                    
                                    self.whichAlert = .first
                                    restoreAlert = true
                                    print("restoreAlert:\(restoreAlert)")
                                    
                                    let defaults = UserDefaults.standard
                                    defaults.set("true", forKey: "lap234")
                                    defaults.set(true, forKey: "Buttondisable")
                                    defaults.set("購入済み", forKey: "Buttonlabel")
                                    
                                }
                            }}else {
                                self.whichAlert = .second
                                restoreAlert = true
                            }
                    }})
                {
                    TextView2(label : "復元する")
                }
                .buttonStyle(MyButtonStyle2())
                .alert(isPresented: $restoreAlert) {
                    switch whichAlert {
                    case .first:
                        return Alert(title: Text("購入履歴が復元されました。"), message: Text(""),dismissButton: .default(Text("OK"),
                                                                                                                  action: {
                            restoreAlert = false
                            self.presentationMode.wrappedValue.dismiss()
                        }))
                    case .second:
                        return Alert(title: Text("復元できませんでした。"),message: Text(""), dismissButton: .default(Text("OK"),
                                                                                                                action: {
                            restoreAlert = false
                        }))
                    }}
                Spacer().frame(height: 35)
            }
            .onAppear() {
                print("restoreAlert:\(restoreAlert)")
                SwiftyStoreKit.retrieveProductsInfo(["lap50"]) { result in
                    if let product = result.retrievedProducts.first {
                        let priceString = product.localizedPrice!
                        print("Product: \(product.localizedDescription), price: \(priceString)")
                    }
                    else if let invalidProductId = result.invalidProductIDs.first {
                        print("Invalid product identifier: \(invalidProductId)")
                    }
                    else {
                        print("Error: \(String(describing: result.error))")
                    }
                }
                
                let userDefaults = UserDefaults.standard
                if let value = userDefaults.string(forKey: "Buttonlabel") {
                    priceLabel = value
                    print("◆◆◆◆◆\(priceLabel)")
                }
                if let value = userDefaults.object(forKey: "Buttondisable") {
                    Buttondisable = value as! Bool
                    print("◆◆◆◆◆\(Buttondisable)")
                }
                if let value = userDefaults.object(forKey: "Restore") {
                    restoreAlert = value as! Bool
                    print("restoreAlert:\(priceLabel)")
                }
            }
            if isPresentedProgressView {
                ZStack{
                    Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 250, height: 120)
                        .cornerRadius(10)
                VStack{
                            ProgressView()
                    Spacer().frame(height: 15)
                    Text("商品情報取得中...")
                        .font(.title)
                }
                    .frame(width: 250, height: 120)
                    .border(Color.black, width: 1)
                }
            }
        }
    }
    private func manageProgress() {
            // ProgressView 表示
            isPresentedProgressView = true
            // 3秒後に非表示に
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isPresentedProgressView = false
            }
        }
    private func manageProgress2() {
            // ProgressView 表示
            isPresentedProgressView = true
            // 3秒後に非表示に
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isPresentedProgressView = false
            }
        }}

