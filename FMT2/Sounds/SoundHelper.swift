import Foundation
import AVFoundation
import NotificationCenter

class SoundHelper {
    static let shared = SoundHelper()
    
    private let backgroundMusicURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Background Loop", ofType: "mp3")!)
    static private let defaultSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Default", ofType: "mp3")!)
    static private let rightAnswerSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Green", ofType: "mp3")!)
    static private let wrongAnswerSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Wrong", ofType: "mp3")!)   
    
    var audioPlayer: AVAudioPlayer?
    
    static var voicePlayer: AVAudioPlayer?
    
    static var clickPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        NotificationCenter.default.addObserver(self, selector: #selector(interruptHandler(notification:)), name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true, with: .notifyOthersOnDeactivation)
            audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusicURL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer?.volume = 0.2
            if UserDefaults.standard.bool(forKey: UserDefaultsKey.soundOn.rawValue) {
                audioPlayer!.play()
            }
        } catch {
            print("Cannot play the file")
        }
    }
    
    func pauseBackgroundMusic() {
        audioPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.soundOn.rawValue) {
            audioPlayer?.play()
        }
    }
    
    @objc func interruptHandler(notification: NSNotification) {
        if notification.name == NSNotification.Name.AVAudioSessionInterruption {
            guard let interruptionType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
            if interruptionType != AVAudioSessionInterruptionType.began.rawValue {
                audioPlayer!.play()
            } else {
                audioPlayer!.pause()
            }
        }
    }
    
    @objc func resumeAfterInterrupt(timer: Timer) {
        audioPlayer!.play()
    }
    
    static func playDefault() {
        play(withURL: defaultSoundURL)
    }
    
    static func playRightAnswer() {
        play(withURL: rightAnswerSoundURL)
    }
    
    static func playWrongAnswer() {
        play(withURL: wrongAnswerSoundURL)
    }

    static func prepareDefault() {
        prepare(withURL: defaultSoundURL)
    }

    static func prepareRightAnswer() {
        prepare(withURL: rightAnswerSoundURL)
    }

    static func prepareWrongAnswer() {
        prepare(withURL: wrongAnswerSoundURL)
    }

    static func prepareButtonSounds() {
        [
            prepareDefault,
            prepareRightAnswer,
            prepareWrongAnswer
        ].forEach{$0()}
    }
    
    static private func play(withURL url: URL) {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.soundOn.rawValue) else {
            return
        }
        do {
            self.clickPlayer = try AVAudioPlayer(contentsOf:url)
            self.clickPlayer?.prepareToPlay()
            self.clickPlayer?.play()
        } catch {
            print("Cannot play the file")
        }
    }    
    
    static private func prepare(withURL url: URL) {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.soundOn.rawValue) else {
            return
        }
        do {
            self.clickPlayer = try AVAudioPlayer(contentsOf:url)
            self.clickPlayer?.prepareToPlay()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func playVoice(name: String) {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.voiceOn.rawValue) else {
            return
        }
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        SoundHelper.voicePlayer = try? AVAudioPlayer(contentsOf: url)
        SoundHelper.voicePlayer?.prepareToPlay()
        SoundHelper.voicePlayer?.play()
    }
    
    func duration(_ soundName: String) -> Double {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        return CMTimeGetSeconds(AVURLAsset(url: url).duration)
    }
    
    func stopVoice() {
        SoundHelper.voicePlayer?.stop()
    }
}
