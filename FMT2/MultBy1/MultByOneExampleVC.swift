import UIKit

class MultByOneExampleVC: FadeInOutVC, IsGameVC {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var result: UIImageView!
    
    @IBOutlet weak var firstDigitEx: UIImageView!
    @IBOutlet weak var secondDigitEx: UIImageView!
    @IBOutlet weak var answerFirstDigit: UIImageView!
    @IBOutlet weak var multiplicationEx: UIImageView!
    @IBOutlet weak var equalityEx: UIImageView!
    
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var newGameButton: TopButton!
    
    var globalStagePassing: GlobalStagePassing!
    
    var isGameViewController: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(Game.current.currentGlobalStagePassing.progress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
        perform(#selector(nextScreen), with: nil, afterDelay: 3)
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [
            [background, firstDigit, secondDigit, result], 
            [firstDigitEx, secondDigitEx, answerFirstDigit, multiplicationEx, equalityEx]
        ]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [
            [background, firstDigit, secondDigit, result], 
            [firstDigitEx, secondDigitEx, answerFirstDigit, multiplicationEx, equalityEx]
        ]
    }
    
    func nextScreen() {
        let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        vc.mode = .afterOneTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
}
