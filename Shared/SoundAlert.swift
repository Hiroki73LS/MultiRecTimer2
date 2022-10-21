import SwiftUI
import AVFoundation


class SoundAlert:ObservableObject{
    
    @ObservedObject var stopWatchManeger = StopWatchManeger()
    @Published var oldMin = 0
    @State var minutes = 0
    private var kaisuu = 0
    private var timer = Timer()
    
    //■■■■■■■■■■■■■■■■サウンド再生■■■■■■■■■■■■■■■■
//    private var Sound = try!  AVAudioPlayer(data: NSDataAsset(name: "gunjyo")!.data)
    
    private var Sound = try!  AVAudioPlayer(data: NSDataAsset(name: "keikoku")!.data)
    
    private func playSound(){
        Sound.stop()
        Sound.currentTime = 2.5
        Sound.play()
    }
    private func playSound2(){
        Sound.stop()
    }
    //■■■■■■■■■■■■■■■■サウンド再生■■■■■■■■■■■■■■■■
    
    func start() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ timer in
            
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async { [self] in
                
                if self.oldMin != StopWatchManeger.Min {
                    
                    print("####\(self.oldMin)######\(StopWatchManeger.Min)#####")
                    
                    self.oldMin = StopWatchManeger.Min
                    Sound.volume = 1
                    self.kaisuu = 0
                    playSound()
                    print(Thread.isMainThread)  // false
                    AudioServicesPlaySystemSound(SystemSoundID(1102))
                }
            }
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    func stop(){
        timer.invalidate()
        print("stop")
        oldMin = 0
        playSound2()
    }
    
    func pause(){
        timer.invalidate()
        print("pause")
    }
}