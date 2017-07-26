import UIKit
import QuartzCore

class VariantButton: LeapingButton {

    var isWrongAnswer: Bool = true
    
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
                self.body.image = #imageLiteral(resourceName: "WrongVariantButton")
            }, completion: { (completed) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    UIView.transition(with: self.body, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.body.image = #imageLiteral(resourceName: "VariantButton")
                    })
                }
            })
        } else {
            UIView.transition(with: self.body, duration: 0.2, options: .transitionCrossDissolve, animations: { 
                self.body.image = #imageLiteral(resourceName: "RightVariantButton")
            }, completion: nil)
        }
    }
    
    override func playSound() {
        isWrongAnswer ? SoundHelper.playWrongAnswer() : SoundHelper.playRightAnswer()
        isWrongAnswer ? playWrongVoice() : playRightVoice()
    }
    
    func playRightVoice() {
        let rand = Int.random(min: 0, max: 2)
        SoundHelper.shared.playVoice(name: "right\(rand)")
    }
    
    func playWrongVoice() {
        let rand = Int.random(min: 0, max: 3)
        SoundHelper.shared.playVoice(name: "wrong\(rand)")
    }
}
