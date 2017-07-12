import UIKit

class MultByTenExampleVC: FadeInOutVC, IsGameVC {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var result: UIImageView!
    
    @IBOutlet weak var firstDigitEx: UIImageView!
    @IBOutlet weak var secondDigitEx: UIImageView!
    @IBOutlet weak var secondDigitEx2: UIImageView!
    @IBOutlet weak var answerFirstDigit: UIImageView!
    @IBOutlet weak var multiplicationEx: UIImageView!
    @IBOutlet weak var equalityEx: UIImageView!
    @IBOutlet weak var answerSecondDigit: UIImageView!
    
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var newGameButton: TopButton!
    
    var globalStagePassing: GlobalStagePassing!
    
    let digitWidth = 40.0 * UIScreen.main.bounds.width / 414.0
    let signWidth = 30.0 * UIScreen.main.bounds.width / 414.0
    
    @IBOutlet weak var firstDigitWidth: NSLayoutConstraint!
    @IBOutlet weak var equalityWidth: NSLayoutConstraint!
    @IBOutlet weak var secondDigitWidth: NSLayoutConstraint!
    @IBOutlet weak var secondDigitWidth2: NSLayoutConstraint!
    @IBOutlet weak var multiplicationWidth: NSLayoutConstraint!
    @IBOutlet weak var resultWidth: NSLayoutConstraint!
    @IBOutlet weak var resultWidth2: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExerciseSize()
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(Game.current.currentGlobalStagePassing.progress)
        perform(#selector(nextScreen), with: nil, afterDelay: 3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalStagePassing.updateElapsedTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureExerciseSize() {
        [firstDigitWidth, secondDigitWidth, secondDigitWidth2, resultWidth, resultWidth2].forEach{$0?.constant = self.digitWidth}
        [equalityWidth, multiplicationWidth].forEach{$0?.constant = self.signWidth} 
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [ 
            [firstDigitEx, secondDigitEx, secondDigitEx2, answerFirstDigit, answerSecondDigit, multiplicationEx, equalityEx]
        ]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [
            [background, firstDigit, secondDigit, result], 
            [firstDigitEx, secondDigitEx, secondDigitEx2, answerFirstDigit, answerSecondDigit, multiplicationEx, equalityEx]
        ]
    }
    
    func nextScreen() {
        let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        vc.mode = .afterTenTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
}
