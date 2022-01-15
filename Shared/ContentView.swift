
import SwiftUI
import GoogleMobileAds

struct AdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
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
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing:2) {
                AdView()
                    .frame(width: 320, height: 50)
                
                    Text("Total Time").font(.title)
                
                if stopWatchManeger.hour > 0 {
                    Text(String(format: "%02d:%02d:%02d.%02d", stopWatchManeger.hour, stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond))
                        .font(.system(size: 55, design: .monospaced))
                } else {
                Text(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond))
                    .font(.system(size: 60, design: .monospaced))
                }
                
                if profile.mode == true{
                    
                    HStack{
                        VStack{
                            HStack{
                                Toggle("", isOn: $profile.mode)
                                .labelsHidden()
                                Text(profile.mode ? "Left mode" : "Right mode")
                            }
                            Text("現在のLapTime")
                                .font(.title)
                            if stopWatchManeger2.hour > 0 {
                                Text(String(format: "%02d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                    .font(.system(size: 33, design: .monospaced))
                            } else {
                            Text(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                .font(.system(size: 40, design: .monospaced))
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
                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
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
                                    total.insert(String(format: "%02d:%02d.%02d", stopWatchManeger.minutes, stopWatchManeger.second, stopWatchManeger.milliSecond), at: 0)
                                    laptime.insert(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond), at: 0)
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
                                    self.stopWatchManeger.stop()
                                    self.stopWatchManeger2.stop()
                                }){
                                    TextView(label : "リセット")
                                    
                                }
                            }
                        }
                        Spacer()
                            .frame(width: 20, height: 100)
                        VStack{
                            HStack{
                                Text(profile.mode ? "Left mode" : "Right mode")
                                Toggle("", isOn: $profile.mode)
                                .labelsHidden()
                            }
                            Text("現在のLapTime")
                                .font(.title)
                            if stopWatchManeger2.hour > 0 {
                                Text(String(format: "%02d:%02d:%02d.%02d", stopWatchManeger2.hour, stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                    .font(.system(size: 33, design: .monospaced))
                            } else {
                            Text(String(format: "%02d:%02d.%02d", stopWatchManeger2.minutes, stopWatchManeger2.second, stopWatchManeger2.milliSecond))
                                .font(.system(size: 40, design: .monospaced))
                            }
                        }
                    }
                }
                
                HStack{
                    Text("No.")
                    Spacer()
                    Text("Lap Time")
                    Spacer()
                    Text("Total Time　")
                }
                List {
                    ForEach(0 ..< total.count, id: \.self) { index in
                        HStack(spacing:5){
                            VStack{
                                Text("Lap")
                                    .font(.system(size: 15, design: .monospaced))
                                Text(lapNo[index])
                                    .font(.system(size: 20, design: .monospaced))
                            }
                            Spacer()
                            Text(laptime[index])
                                .font(.system(size: 40, design: .monospaced))
                            Spacer()
                            Text("\(total[index])")
                                .font(.system(size: 20, design: .monospaced))
                        }.listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                    }
                }.listStyle(PlainListStyle())
                    .font(.largeTitle)
            }
        }
        .onChange(of: profile.mode) { mode in
            UserDefaults.standard.set(profile.mode , forKey: "mode")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(total: [], laptime: [], lapNo: [], lapn : 0, nowTime: 0)
    }}

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

            // 時は経過分を60で割った商
            self.hour = Int(self.minutes / 60)
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
            print("\(self.displayTime)")
            
            self.elapsedTime += 0.01
            // ミリ秒は小数点第一位、第二位なので100をかけて100で割った余り
            self.milliSecond = Int(self.displayTime * 100) % 100
            
            // 秒は1・2桁なので60で割った余り
            self.second = Int(self.displayTime) % 60
            
            // 分は経過秒を60で割った商を60で割った余り
            self.minutes = Int(self.displayTime / 60) % 60

            // 時は経過分を60で割った商
            self.hour = Int(self.minutes / 60)
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
            .foregroundColor(.orange)
    }
}
