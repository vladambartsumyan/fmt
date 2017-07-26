import Foundation
import AVFoundation

class SoundHelper {
    static let shared = SoundHelper()
    
    private let backgroundMusicURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Background Loop", ofType: "mp3")!)
    static private let defaultSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Default", ofType: "mp3")!)
    static private let rightAnswerSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Green", ofType: "mp3")!)
    static private let wrongAnswerSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Wrong", ofType: "mp3")!)   
    
    var audioPlayer: AVAudioPlayer?
    
    var voicePlayer: AVAudioPlayer?
    
    static var clickPlayer: AVAudioPlayer?
    func playBackgroundMusic() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusicURL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer?.volume = 0.2
            if UserDefaults.standard.bool(forKey: "soundOn") {
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
        if UserDefaults.standard.bool(forKey: "soundOn") {
            audioPlayer?.play()
        }
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
        guard UserDefaults.standard.bool(forKey: "soundOn") else {
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
        guard UserDefaults.standard.bool(forKey: "soundOn") else {
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
        guard UserDefaults.standard.bool(forKey: "soundOn") else {
            return
        }
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        voicePlayer = try? AVAudioPlayer(contentsOf: url)
        voicePlayer?.prepareToPlay()
        voicePlayer?.play()
    }
    
    func duration(_ soundName: String) -> Double {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        return CMTimeGetSeconds(AVURLAsset(url: url).duration)
    }
    
    func stopVoice() {
        voicePlayer?.stop()
    }
}
