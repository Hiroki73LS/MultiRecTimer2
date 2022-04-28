import SwiftUI

struct FirstLaunch: View {
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Image("123")
        }
    }
}
