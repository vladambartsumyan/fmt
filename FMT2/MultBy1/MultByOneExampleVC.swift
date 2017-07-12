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
    
    let digitWidth = 40.0 * UIScreen.main.bounds.width / 414.0
    let signWidth = 30.0 * UIScreen.main.bounds.width / 414.0
    
    @IBOutlet weak var firstDigitWidth: NSLayoutConstraint!
    @IBOutlet weak var equalityWidth: NSLayoutConstraint!
    @IBOutlet weak var secondDigitWidth: NSLayoutConstraint!
    @IBOutlet weak var multiplicationWidth: NSLayoutConstraint!
    @IBOutlet weak var resultWidth: NSLayoutConstraint!
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExerciseSize()
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(Game.current.currentGlobalStagePassing.progress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn()
        perform(#selector(nextScreen), with: nil, afterDelay: 3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        globalStagePassing.updateElapsedTime()
    }
    
    func configureExerciseSize() {
        [firstDigitWidth, secondDigitWidth, resultWidth].forEach{$0?.constant = self.digitWidth}
        [equalityWidth, multiplicationWidth].forEach{$0?.constant = self.signWidth} 
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
