import UIKit
import AVFoundation
import SVGKit

class TutorialVC: FadeInOutVC {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var firstOperand: UIImageView!
    @IBOutlet weak var multMark: UIImageView!
    @IBOutlet weak var secondOperand: UIImageView!
    @IBOutlet weak var equalMark: UIImageView!
    @IBOutlet weak var questionMark: UIImageView!
    @IBOutlet weak var answerFirstDigit: UIImageView!
    
    let durationOfIntro = SoundHelper.shared.duration("intro")
    let durationOfTutorial1 = SoundHelper.shared.duration("tutorial1")
    let durationOfTutorial2 = SoundHelper.shared.duration("tutorial2")
    
    var images: [UIView] = []
    var exercise: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImages()
        Game.current.createGame()
        [backgroundImage, firstDigit, secondDigit, resultImage, firstOperand, multMark, secondOperand, equalMark, questionMark, answerFirstDigit].forEach {
            $0?.alpha = 0
        }
        images = [backgroundImage, firstDigit, secondDigit]
        exercise = [firstOperand, multMark, secondOperand, equalMark, questionMark]
    }

    override func viewDidAppear(_ animated: Bool) {
        presentation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SoundHelper.shared.stopVoice()
        trackScreen(screen: .tutorial)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureImages() {
        background.image = SVGKImage(named: "background").uiImage
        backgroundImage.image = SVGKImage(named: "x23background").uiImage
        firstDigit.image = SVGKImage(named: "x232brown").uiImage
        secondDigit.image = SVGKImage(named: "x233gray").uiImage
        resultImage.image = SVGKImage(named: "x23result").uiImage
        firstOperand.image = UIImage(named: "2exercise")
        multMark.image = UIImage(named: "xexercise")
        secondOperand.image = UIImage(named: "3exercise")
        equalMark.image = UIImage(named: "=exercise")
        questionMark.image = UIImage(named: "?exercise")
        answerFirstDigit.image = UIImage(named: "6exercise")
    }
    
    func presentation() {
        perform(#selector(showImages), with: nil, afterDelay: 1.5)
        perform(#selector(showResult), with: nil, afterDelay: 1.5 + durationOfIntro + durationOfTutorial1 - 3)
        perform(#selector(showExercise), with: nil, afterDelay: 1.5 + durationOfIntro + durationOfTutorial1)
        perform(#selector(showAnswer), with: nil, afterDelay: 2.5 + durationOfIntro + durationOfTutorial1 + durationOfTutorial2 - 3)
        perform(#selector(nextScreen), with: nil, afterDelay: durationOfIntro + durationOfTutorial1 + durationOfTutorial2 + 4)
        
        perform(#selector(play), with: "intro", afterDelay: 1.5)
        perform(#selector(play), with: "tutorial1", afterDelay: 2.5 + durationOfIntro)
        perform(#selector(play), with: "tutorial2", afterDelay: 4 + durationOfIntro + durationOfTutorial1)
    }
    
    func play(_ name: String) {
        SoundHelper.shared.playVoice(name: name)
    }
    
    func showImages() {
        UIView.animate(withDuration: 0.5) {
            for view in self.images {
                view.alpha = 1.0
            }
        }
    }
    
    func showResult() {
        resultImage.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.2, animations: {
            self.resultImage.alpha = 1
            self.resultImage.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 1, animations: {
                self.resultImage.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
    
    func showExercise() {
        UIView.animate(withDuration: 0.5) {
            for view in self.exercise {
                view.alpha = 1.0
            }
        }
    }
    
    func showAnswer() {
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: 0.0, y: 40.0)
        t = t.scaledBy(x: 0.5, y: 1.0)
        self.answerFirstDigit.alpha = 0.0
        answerFirstDigit.isHidden = false
        answerFirstDigit.transform = t
        UIView.animate(withDuration: 0.2, animations: { 
            self.answerFirstDigit.transform = CGAffineTransform.identity
            self.questionMark.alpha = 0.0
            self.answerFirstDigit.alpha = 1.0
        })
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [
            [backgroundImage, firstDigit, secondDigit, resultImage],
            [firstOperand, multMark, secondOperand, equalMark, questionMark, answerFirstDigit]
        ]
    }
    
    func nextScreen() {
        fadeOut {
            let vc = StageMapVC(nibName: "StageMapVC", bundle: nil)
            AppDelegate.current.setRootVC(vc)
        }
    }
}
