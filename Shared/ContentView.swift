
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


struct ContentView: View {
    
    @ObservedObject var stopWatchManeger = StopWatchManeger()
    @State var total : [String] = ["0.00"]
    @State var laptime : [String] = ["0.00"]
    @State var laptimeTemp : Double = 0.00
    @State var lapNo : [String]
    @State var lapn = 0

    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing:10) {
                AdView()
                    .frame(width: 320, height: 50)
                Text("Total Time")
                HStack{
                    Text("0:")
                    Text(String(format:"%.2f",stopWatchManeger.secondsElapsed))
                }
                .font(.system(size: 60, design: .monospaced))
                HStack{
                    VStack{
                        Spacer()
                            .frame(width: 200, height: 100)
//                        Text("ラップタイム")
//                            .font(.largeTitle)
                    }
                    
                    if stopWatchManeger.mode == .stop{
                        VStack{
                            Button(action: {
                                self.stopWatchManeger.start()
                            }){
                                TextView(label : "スタート")
                            }
                            Button(action: {
                                total.removeAll()
                                laptime.removeAll()
                                lapNo.removeAll()
                                total[0] = "0"
                                laptime[0] = "0"
                                lapNo[0] = "0"
                                self.stopWatchManeger.stop()
                            }){
                                TextView(label : "リセット")
                            }                }
                    }
                    
                    if stopWatchManeger.mode == .start{
                        VStack{
                            Button(action: {self.stopWatchManeger.pause()}){
                                TextView(label : "一時停止")
                            }
                            Button(action: {
                                print(total[0])
                                laptimeTemp = (Double(stopWatchManeger.secondsElapsed) as? Double)! - Double(total[0])!
                                
                                lapNo.insert(String(lapn), at: 0)
                                total.insert(String(format:"%.2f",stopWatchManeger.secondsElapsed), at: 0)
                                laptime.insert(String(format:"%.2f",laptimeTemp), at: 0)
                                
                                lapn += 1
                            }){
                                TextView(label : "ラップ")
                            }}
                    }
                    
                    if stopWatchManeger.mode == .pause{
                        VStack{
                            Button(action: {self.stopWatchManeger.start()}){
                                TextView(label : "再開")
                            }
                            Button(action: {
                                total.removeAll()
                                laptime.removeAll()
                                lapNo.removeAll()
                                total[0] = "0.00"
                                laptime[0] = "0.00"
                                lapNo[0] = "0"
                                self.stopWatchManeger.stop()
                            }){
                                TextView(label : "リセット")
                                
                            }
                        }
                    }
                }
                HStack{
                    Text("　No.")
                    Spacer()
                    Text("Lap Time")
                    Spacer()
                    Text("Total Time　")
                }
                List {
                    ForEach(0 ..< total.count, id: \.self) { index in
                        HStack{
                            VStack{
                                Text("LAP")
                                    .font(.system(size: 15, design: .monospaced))
                                Text(lapNo[index])
                                    .font(.system(size: 20, design: .monospaced))
                            }
                            Spacer()
                            Text(laptime[index])
                                .font(.system(size: 50, design: .monospaced))
                                .listRowBackground(Color.red)
                            Spacer()
                            Text("(\(total[index]))")
                                .font(.system(size: 30, design: .monospaced))
                                .listRowBackground(Color.red)
                        }}
                }.listStyle(PlainListStyle())
                    .font(.largeTitle)
            }
        }.onChange(of: scenePhase) { phase in
            if phase == .background {
                print("バックグラウンド！")
            }
            if phase == .active {
                print("フォアグラウンド！")
            }
            if phase == .inactive {
                print("バックグラウンドorフォアグラウンド直前")
            }
        }
    }}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(total: ["0.00"], laptime: ["0.00"],laptimeTemp: 0.00 , lapNo: ["0"], lapn : 0)
    }}


class StopWatchManeger:ObservableObject{
    
    enum stopWatchMode{
        case start
        case stop
        case pause
    }
    
    @Published var mode:stopWatchMode = .stop
    
    @Published var secondsElapsed = 0.00
    var timer = Timer()
    
    func start(){
        mode = .start
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ timer in
            self.secondsElapsed += 0.01
//            print("\(self.secondsElapsed)")
        }
    }
    
    func stop(){
        timer.invalidate()
        secondsElapsed = 0
        mode = .stop
    }
    
    func pause(){
        timer.invalidate()
        mode = .pause
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
            .foregroundColor(.orange)
    }
}
