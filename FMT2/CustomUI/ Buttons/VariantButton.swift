import UIKit
import QuartzCore
import SVGKit

class VariantButton: LeapingButton {

    var isWrongAnswer: Bool = true
    var rand = 0
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("VariantButton", owner: self, options: nil)
        self.view.frame = self.frame
        self.view.center = self.center - self.frame.origin
        setTitleSize()
        self.addSubview(self.view)
        self.body.image = SVGKImage.init(named: "variantButton").uiImage
    }

    func setTitle(titleText title: String) {
        self.titleUp.text = title
        self.titleDown.text = title
        self.titleLeft.text = title
        self.titleRight.text = title
    }

    func setTitleSize() {
        let font = UIFont.init(name: "Lato-Black", size: 37 * UIScreen.main.bounds.width / 414)
        self.titleUp.font = font
        self.titleDown.font = font
        self.titleRight.font = font
        self.titleLeft.font = font
    }

    override func touchUp() {
        super.touchUp()
        if isWrongAnswer {
            UIView.transition(with: self.body, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.body.image = SVGKImage.init(named: "wrongVariantButton").uiImage
            }, completion: { (completed) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    UIView.transition(with: self.body, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.body.image = SVGKImage.init(named: "variantButton").uiImage
                    })
                }
            })
        } else {
            UIView.transition(with: self.body, duration: 0.2, options: .transitionCrossDissolve, animations: { 
                self.body.image = SVGKImage.init(named: "rightVariantButton").uiImage
            }, completion: nil)
        }
    }
    
    override func playSound() {
        isWrongAnswer ? SoundHelper.playWrongAnswer() : SoundHelper.playRightAnswer()
        isWrongAnswer ? playWrongVoice() : playRightVoice()
    }
    
    func playRightVoice() {
        rand = Int.random(min: 0, max: 2)
        SoundHelper.shared.playVoice(name: "right\(rand)")
    }
    
    func playWrongVoice() {
        rand = Int.random(min: 0, max: 3)
        SoundHelper.shared.playVoice(name: "wrong\(rand)")
    }
    
    var voiceDuration: Double {
        return UserDefaults.standard.bool(forKey: "soundOn") ? SoundHelper.shared.duration(isWrongAnswer ? "wrong\(rand)" : "right\(rand)") : 0
    }
}
