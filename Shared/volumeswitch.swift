import SwiftUI
import MediaPlayer

class VolSwitch:ObservableObject{
    
    var initialVolume: Float = 0.0
      var volumeView: MPVolumeView!
    
    func startListeningVolumeButton() {
        // MPVolumeViewを画面の外側に追い出して見えないようにする
        let frame = CGRect(x: -100, y: -100, width: 100, height: 100)
        volumeView = MPVolumeView(frame: frame)
        volumeView.sizeToFit()
        view.addSubview(volumeView)

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            // AVAudioSessionの出力音量を取得して、最大音量と無音に振り切れないように初期音量を設定する
            let vol = audioSession.outputVolume
            initialVolume = Float(vol.description)!
            if initialVolume > 0.9 {
                initialVolume = 0.9
            } else if initialVolume < 0.1 {
                initialVolume = 0.1
            }
            setVolume(initialVolume)
            // 出力音量の監視を開始
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: .new, context: nil)
        } catch {
            print("Could not observer outputVolume ", error)
        }
    }

    func stopListeningVolumeButton() {
        // 出力音量の監視を終了
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
        // ボリュームビューを破棄
        volumeView.removeFromSuperview()
        volumeView = nil
    }
    
    func setVolume(_ volume: Float) {
        (volumeView.subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(initialVolume, animated: false)
    }
    
    

}
