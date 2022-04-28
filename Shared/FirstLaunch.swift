import SwiftUI

struct FirstLaunch: View {
    
    @Binding var isAActive: Bool
    @State var screen2: CGSize?
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer().frame(height: 30)
                Text("ダウンロードありがとうございます。").bold().font(.title3)
                VStack(alignment: .leading){
                    Spacer().frame(height: 10)
                    
                    Text(" 【 履歴保存機能の使い方 】")
                    VStack(alignment: .leading){
                        Text("１.「スタート」ボタンで計測開始")
                        Text("２.「一時停止」ボタンで計測停止")
                        Text("３.「リセット」ボタンを押すと")
                        Text("  　リセットと同時に履歴が自動で")
                        Text("  　保存されます。")
                    }.frame(width: (screen2?.width ?? 100) * 0.95 , height: 150)
                    .border(Color.black, width: 2)
                    
                    Spacer().frame(height: 15)
                    Text(" 【 favoriteマークの使い方 】")
                    VStack(alignment: .leading){
                        Text("「favorite」ボタンを押すとマークの")
                        Text("色は変わりますが、プロテクト機能")
                        Text("ではありませんのでご注意ください。")
                    }.frame(width: (screen2?.width ?? 100) * 0.95 , height: 130)
                    .border(Color.black, width: 2)
                    
                    Text("※履歴保存上限数以上の履歴は")
                    Text(" 古いものから自動で削除されます。")
                }.font(.title2)
                    .frame(width: (screen2?.width ?? 100) * 0.95)
                
                Button(action: {
                    isAActive = false
                })
                {
                    TextView4(label : "確認しました。")
                }
                .buttonStyle(MyButtonStyle2())
                Spacer()
            }
        }.onAppear {
            screen2 = UIScreen.main.bounds.size
        }
    }
}
