
import SwiftUI
import GoogleMobileAds
import SwiftyStoreKit

struct AdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
//        banner.adUnitID = "ca-app-pub-1023155372875273/2954960110"


        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}

class UserProfile: ObservableObject {
    /// ユーザ名
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    /// レベル
    @Published var level: Int {
        didSet {
            UserDefaults.standard.set(level, forKey: "level")
        }
    }
    /// 利き手のモード値
    @Published var mode: Bool {
        didSet {
            UserDefaults.standard.set(mode, forKey: "mode")
        }
    }
    /// 初期化処理
    init() {
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        level = UserDefaults.standard.object(forKey: "level") as? Int ?? 1
        mode = UserDefaults.standard.object(forKey: "mode") as? Bool ?? true
    }
}


struct ContentView: View {
    
    @ObservedObject var profile = UserProfile()
    @ObservedObject var stopWatchManeger = StopWatchManeger()
    @ObservedObject var stopWatchManeger2 = StopWatchManeger2()
    @State var total : [String]
    @State var laptime : [String]
    @State var lapNo : [String]
    @State var lapn = 1
    @State var milliSecond = 0
    @State var Second = 0
    @State var minites = 0
    @State var hour = 0
    @State var flag = true
    @State var nowTime : Double
    @State var sheetAlert : Bool = false
        
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing:2) {
                AdView()
                    .frame(width: 320, height: 50)
                
                    Text("Total Time").font(.title)
               
                if stopWatchManeger.hour > 0 {
                    Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond))
                        .font(Font.custom("HiraginoSans-W3", size: 65))
                        .font(.system(size: 60, design: .monospaced))
                } else {
                    Text(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond))
                        .font(Font.custom("HiraginoSans-W3", size: 80))
                        .font(.system(size: 80, design: .monospaced))
                }
                
                if profile.mode == true{
                    
                    HStack{
                        VStack{
                            HStack{
                                Button(action: {
                                    self.sheetAlert.toggle()
                                }) {
                                    Text("課金")
                                        .font(.title)
                                        .foregroundColor(Color.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color(.black), lineWidth: 1.0)
                                        )
                                }.sheet(isPresented: $sheetAlert) {
                                    SecondView()
                                }
                                Toggle("", isOn: $profile.mode)
                                    .labelsHidden()
                                Text(profile.mode ? "Left mode" : "Right mode")
                            }
                            Text("現在のLapTime")
                                .font(.title)
                            if stopWatchManeger2.hour > 0 {
                                Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                    .font(Font.custom("HiraginoSans-W3", size: 40))
                                    .font(.system(size: 40, design: .monospaced))
                            } else {
                                Text(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                    .font(Font.custom("HiraginoSans-W3", size: 50))
                                    .font(.system(size: 50, design: .monospaced))
                            }
                        }
                        if stopWatchManeger.mode == .stop{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.start()
                                    self.stopWatchManeger2.start()
                                }){
                                    TextView(label : "スタート")
                                }
                                Button(action: {
                                    total.removeAll()
                                    laptime.removeAll()
                                    lapNo.removeAll()
                                    lapn = 1
                                    self.stopWatchManeger.stop()
                                    self.stopWatchManeger2.stop()
                                }){
                                    TextView(label : "リセット")
                                }                }
                        }
                        if stopWatchManeger.mode == .start{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.pause()
                                    self.stopWatchManeger2.pause()
                                }){
                                    TextView(label : "一時停止")
                                }
                                Button(action: {
                                    lapNo.insert(String(lapn), at: 0)
                                    
                                    if stopWatchManeger.hour > 0 {
                                        total.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                    } else {
                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                    }
                                    if stopWatchManeger2.hour > 0 {
                                        laptime.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                    } else {
                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                    }
                                    
                                    self.stopWatchManeger2.pause()
                                    self.stopWatchManeger2.stop()
                                    self.stopWatchManeger2.start()
                                    lapn += 1

                                }){
                                    TextView(label : "ラップ")
                                }}
                        }
                        
                        if stopWatchManeger.mode == .pause{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.start()
                                    self.stopWatchManeger2.start()
                                }){
                                    TextView(label : "再開")
                                }
                                Button(action: {
                                    total.removeAll()
                                    laptime.removeAll()
                                    lapNo.removeAll()
                                    lapn = 1
                                    stopWatchManeger.minutes = 00
                                    stopWatchManeger.second = 00
                                    stopWatchManeger.milliSecond = 00
                                    stopWatchManeger.hour = 00
                                    stopWatchManeger2.minutes = 00
                                    stopWatchManeger2.second = 00
                                    stopWatchManeger2.milliSecond = 00
                                    stopWatchManeger2.hour = 00
                                    self.stopWatchManeger.stop()
                                    self.stopWatchManeger2.stop()
                                }){
                                    TextView(label : "リセット")
                                    
                                }
                            }
                        }
                    }
                }
                
                if profile.mode == false{
                    
                    HStack{
                        if stopWatchManeger.mode == .stop{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.start()
                                    self.stopWatchManeger2.start()
                                }){
                                    TextView(label : "スタート")
                                }
                                Button(action: {
                                    total.removeAll()
                                    laptime.removeAll()
                                    lapNo.removeAll()
                                    lapn = 1
                                    self.stopWatchManeger.stop()
                                    self.stopWatchManeger2.stop()
                                }){
                                    TextView(label : "リセット")
                                }                }
                        }
                        
                        if stopWatchManeger.mode == .start{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.pause()
                                    self.stopWatchManeger2.pause()
                                }){
                                    TextView(label : "一時停止")
                                }
                                Button(action: {
                                    lapNo.insert(String(lapn), at: 0)
                                    
                                    if stopWatchManeger.hour > 0 {
                                        total.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                    } else {
                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                    }
                                    if stopWatchManeger2.hour > 0 {
                                        laptime.insert(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                    } else {
                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
                                    }
                                    
                                    self.stopWatchManeger2.pause()
                                    self.stopWatchManeger2.stop()
                                    self.stopWatchManeger2.start()
                                    lapn += 1
                                }){
                                    TextView(label : "ラップ")
                                }}
                        }
                        
                        if stopWatchManeger.mode == .pause{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.start()
                                    self.stopWatchManeger2.start()
                                }){
                                    TextView(label : "再開")
                                }
                                Button(action: {
                                    total.removeAll()
                                    laptime.removeAll()
                                    lapNo.removeAll()
                                    lapn = 1
                                    stopWatchManeger.minutes = 00
                                    stopWatchManeger.second = 00
                                    stopWatchManeger.milliSecond = 00
                                    stopWatchManeger2.minutes = 00
                                    stopWatchManeger2.second = 00
                                    stopWatchManeger2.milliSecond = 00
                                    stopWatchManeger2.hour = 00
                                    self.stopWatchManeger.stop()
                                    self.stopWatchManeger2.stop()
                                }){
                                    TextView(label : "リセット")
                                    
                                }
                            }
                        }
                        VStack{
                            HStack{
                                Text(profile.mode ? "Left mode" : "Right mode")
                                Toggle("", isOn: $profile.mode)
                                    .labelsHidden()
                                Button(action: {
                                    self.sheetAlert.toggle()
                                }) {
                                    Text("課金")
                                        .font(.title)
                                        .foregroundColor(Color.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color(.black), lineWidth: 1.0)
                                        )
                                }.sheet(isPresented: $sheetAlert) {
                                    SecondView()
                                }
                            }
                            Text("現在のLapTime")
                                .font(.title)
                            if stopWatchManeger2.hour > 0 {
                                Text(String(format: "%01d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                    .font(Font.custom("HiraginoSans-W3", size: 40))
                                    .font(.system(size: 40, design: .monospaced))
                            } else {
                                Text(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                    .font(Font.custom("HiraginoSans-W3", size: 50))
                                    .font(.system(size: 50, design: .monospaced))
                            }
                        }
                    }
                }
                
                HStack{
                    Text("No.")
                    Spacer()
                    Text("Lap Time")
                    Spacer()
                    Text("Total Time ")
                }
                if stopWatchManeger.hour > 0 {
                    List {
                        ForEach(0 ..< total.count, id: \.self) { index in
                            HStack(spacing:2){
                                VStack{
                                    Text("Lap")
                                        .font(.system(size: 15, design: .monospaced))
                                    Text(lapNo[index])
                                        .font(.system(size: 25, design: .monospaced))
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                    )
                                    Spacer()
                                    Text(laptime[index])
                                        .font(Font.custom("HiraginoSans-W3", size: 38))
                                        .font(.system(size: 40, design: .monospaced))
                                    Spacer()
                                    Text("\(total[index])")
                                        .font(Font.custom("HiraginoSans-W3", size: 20))
                                        .font(.system(size: 20, design: .monospaced))
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color("ColorOrange2"))
                            //                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        }
                    }                .environment(\.defaultMinListRowHeight, 70)
                        .listStyle(PlainListStyle())
                        .font(.largeTitle)
                    
                } else {
                    List {
                        ForEach(0 ..< total.count, id: \.self) { index in
                            HStack(spacing:2){
                                VStack{
                                    Text("Lap")
                                        .font(.system(size: 15, design: .monospaced))
                                    Text(lapNo[index])
                                        .font(.system(size: 25, design: .monospaced))
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                    )
                                Spacer()
                                Text(laptime[index])
                                    .font(Font.custom("HiraginoSans-W3", size: 50))
                                    .font(.system(size: 50, design: .monospaced))
                                Spacer()
                                Text("\(total[index])")
                                    .font(Font.custom("HiraginoSans-W3", size: 20))
                                    .font(.system(size: 20, design: .monospaced))
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color("ColorOrange2"))
                            .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        }
                    }   .environment(\.defaultMinListRowHeight, 70)
                        .listStyle(PlainListStyle())
                        .font(.largeTitle)
                    
                }
            }
        }.onAppear {
            print("aaaaaaaaaaaa")
            SwiftyStoreKit.retrieveProductsInfo(["lap123"]) { result in
                if let product = result.retrievedProducts.first {
                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString)")
                }
                else if let invalidProductId = result.invalidProductIDs.first {
                    print("Invalid product identifier: \(invalidProductId)")
                }
                else {
                    print("Error: \(result.error)")
                }
            }
            
        }
        .onChange(of: profile.mode) { mode in
            UserDefaults.standard.set(profile.mode , forKey: "mode")
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    }

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(total: [], laptime: [], lapNo: [], lapn : 0, nowTime: 0)
//    }}

//------------------------------------------------------------------------------------------------------------------------
class StopWatchManeger:ObservableObject{
    
    enum stopWatchMode{
        case start
        case stop
        case pause
    }
    
    @Published var mode:stopWatchMode = .stop
    
    @Published var milliSecond = 00
    @Published var second = 00
    @Published var minutes = 00
    @Published var hour = 0
    var nowTime : Double = 0
    var elapsedTime : Double = 0
    var displayTime: Double = 0
    var savedTime: Double = 0
    
    var timer = Timer()
    
    func start(){
        mode = .start
        
        self.nowTime = NSDate.timeIntervalSinceReferenceDate
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
            
            self.elapsedTime = NSDate.timeIntervalSinceReferenceDate
            self.displayTime = (self.elapsedTime + self.savedTime) - self.nowTime
            
            // ミリ秒は小数点第一位、第二位なので100をかけて100で割った余り
            self.milliSecond = Int(self.displayTime * 100) % 100
            
            // 秒は1・2桁なので60で割った余り
            self.second = Int(self.displayTime) % 60
            
            // 分は経過秒を60で割った商を60で割った余り
            self.minutes = Int(self.displayTime / 60) % 60
            
            // 時は経過分を60で割った商を60で割る
            self.hour = Int(self.displayTime / 60) / 60
            
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stop(){
        timer.invalidate()
        elapsedTime = 0
        savedTime = 0
        mode = .stop
    }
    
    func pause(){
        timer.invalidate()
        savedTime = displayTime
        mode = .pause
    }
}
//------------------------------------------------------------------------------------------------------------------------
class StopWatchManeger2:ObservableObject{
    
    enum stopWatchMode{
        case start
        case stop
        case pause
    }
    
    @Published var mode:stopWatchMode = .stop
    
    @Published var milliSecond = 00
    @Published var second = 00
    @Published var minutes = 00
    @Published var hour = 0
    var nowTime : Double = 0
    var elapsedTime : Double = 0
    var displayTime: Double = 0
    var savedTime: Double = 0
    
    var timer = Timer()
    
    func start(){
        mode = .start
        
        self.nowTime = NSDate.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
            
            self.elapsedTime = NSDate.timeIntervalSinceReferenceDate
            self.displayTime = (self.elapsedTime + self.savedTime) - self.nowTime

            // ミリ秒は小数点第一位、第二位なので100をかけて100で割った余り
            self.milliSecond = Int(self.displayTime * 100) % 100
            
            // 秒は1・2桁なので60で割った余り
            self.second = Int(self.displayTime) % 60
            
            // 分は経過秒を60で割った商を60で割った余り
            self.minutes = Int(self.displayTime / 60) % 60
            
            // 時は経過分を60で割った商を60で割る
            self.hour = Int(self.displayTime / 60) / 60
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stop(){
        timer.invalidate()
        elapsedTime = 0
        savedTime = 0
        mode = .stop
    }
    
    func pause(){
        timer.invalidate()
        savedTime = displayTime
        mode = .pause
    }
}
//------------------------------------------------------------------------------------------------------------------------


struct TextView2: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.title)
            .frame(width: 130, height: 80, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 200)
                    .stroke(Color.blue, lineWidth: 5)
                
            )
            .foregroundColor(.orange)
    }
}
struct TextView: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.title)
            .frame(width: 130, height: 80, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 200)
                    .stroke(Color.blue, lineWidth: 5)
            )
            .foregroundColor(.black)
    }
}



struct SecondView: View {
    
    @State var restoreAlert : Bool = false
    @State var restoreAlert2 : Bool = false
    @State var restoreAlert3 : Bool = false

    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            

        VStack{
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
                Text("上限数の解除")
                    .font(.largeTitle)
                    .frame(width: 220, height: 50)
                    .foregroundColor(Color(.white))
                    .padding(.all)
                    .background(Color(.blue))
                    .cornerRadius(24)
                    .shadow(color: Color.gray.opacity(0.6), radius: 4, x: 10, y: 10)
            }
            Spacer().frame(height: 30)
            Button(action: {
                SwiftyStoreKit.purchaseProduct("lap234", quantity: 1, atomically: false) { result in
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
                SwiftyStoreKit.retrieveProductsInfo(["lap234"]) { result in
                    if let product = result.retrievedProducts.first {
                        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                            // handle result (same as above)
                        }
                    }
                }
                
                
                
            }){
                Text("広告の非表示")
                    .font(.largeTitle)
                    .frame(width: 220, height: 50)
                    .foregroundColor(Color(.white))
                    .padding(.all)
                    .background(Color(.blue))
                    .cornerRadius(24)
                    .shadow(color: Color.gray.opacity(0.6), radius: 4, x: 10, y: 10)
            }
            Spacer().frame(height: 30)

            Button(action: {
                
                SwiftyStoreKit.restorePurchases(atomically: false) { results in
                    if results.restoreFailedPurchases.count > 0 {
                        self.restoreAlert3 = true
                        print("Restore Failed: \(results.restoreFailedPurchases)")
                    }
                    else if results.restoredPurchases.count > 0 {
                        for purchase in results.restoredPurchases {
                            // fetch content from your server, then:
                            if purchase.needsFinishTransaction {
                                SwiftyStoreKit.finishTransaction(purchase.transaction)
                            }
                        }
                        self.restoreAlert2 = true
                        print("Restore Success: \(results.restoredPurchases)")
                    }
                    else {
                        self.restoreAlert = true          // ②タップされたら表示フラグをtrueにする
                        print("Nothing to Restore")
                    }
                }
            })
            {
                Text("購入の復元")
                    .font(.largeTitle)
                    .frame(width: 220, height: 50)
                    .foregroundColor(Color(.white))
                    .padding(.all)
                    .background(Color(.blue))
                    .cornerRadius(24)
                    .shadow(color: Color.gray.opacity(0.6), radius: 4, x: 10, y: 10)
            }.alert(isPresented: $restoreAlert){
                Alert(title: Text("購入履歴はありません。"))
            }
            .alert(isPresented: $restoreAlert2){
                Alert(title: Text("購入履歴が復元されました。"))
            }
            .alert(isPresented: $restoreAlert3){
                Alert(title: Text("購入履歴復元に失敗しました。"))
            }
            Spacer().frame(height: 200)
        }
        
    }
}
}
