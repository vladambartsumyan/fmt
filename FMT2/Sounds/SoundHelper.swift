import Foundation
import AVFoundation

class SoundHelper {
    static let shared = SoundHelper()
    
    private let backgroundMusicURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Background Loop", ofType: "mp3")!)
    static private let defaultSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Default", ofType: "mp3")!)
    static private let rightAnswerSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Green", ofType: "mp3")!)
    static private let wrongAnswerSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Wrong", ofType: "mp3")!)
    
    var audioPlayer: AVAudioPlayer?
    
    static var clickPlayer: AVAudioPlayer?
    func playBackgroundMusic() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusicURL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer?.volume = 0.4
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
    
    static private func play(withURL url: URL) {
        guard UserDefaults.standard.bool(forKey: "soundOn") else {
            return
        }
        do {
            clickPlayer = try AVAudioPlayer(contentsOf:url)
            clickPlayer?.prepareToPlay()
            clickPlayer?.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
}
