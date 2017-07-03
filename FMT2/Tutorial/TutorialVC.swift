import UIKit

class TutorialVC: FadeInOutVC, IsGameVC {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var firstOperand: UIImageView!
    @IBOutlet weak var multMark: UIImageView!
    @IBOutlet weak var secondOperand: UIImageView!
    @IBOutlet weak var equalMark: UIImageView!
    @IBOutlet weak var questionMark: UIImageView!
    @IBOutlet weak var answerFirstDigit: UIImageView!
    
    var images: [UIView] = []
    var exercise: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.current.createGame()
        [background, firstDigit, secondDigit, resultImage, firstOperand, multMark, secondOperand, equalMark, questionMark, answerFirstDigit].forEach {
            $0?.alpha = 0
        }
        images = [background, firstDigit, secondDigit]
        exercise = [firstOperand, multMark, secondOperand, equalMark, questionMark]
        presentation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func presentation() {
        perform(#selector(showImages), with: nil, afterDelay: 1)
        perform(#selector(showResult), with: nil, afterDelay: 1.5)
        perform(#selector(showExercise), with: nil, afterDelay: 2)
        perform(#selector(showAnswer), with: nil, afterDelay: 2.5)
    }
    
    var isGameViewController: Bool {
        return true
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
        }) { (_) in
            self.nextScreen()
        }
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [
            [background, firstDigit, secondDigit, resultImage],
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
