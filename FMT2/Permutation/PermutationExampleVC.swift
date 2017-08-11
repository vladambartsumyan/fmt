import UIKit
import SVGKit

class PermutationExampleVC: FadeInOutVC, IsGameVC {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
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
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExerciseSize()
        configureImages()
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
        background.image = SVGKImage(named: "background").uiImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            let tutorialName = StageType.permutation.string + "tutorial"
            let tutorialDuration = SoundHelper.shared.duration(tutorialName)
            self.perform(#selector(self.nextScreen), with: nil, afterDelay: tutorialDuration - 5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureExerciseSize() {
        [firstDigitWidth, secondDigitWidth, resultWidth].forEach{$0?.constant = self.digitWidth}
        [equalityWidth, multiplicationWidth].forEach{$0?.constant = self.signWidth} 
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [ 
            [firstDigitEx, secondDigitEx, secondDigitEx2, answerFirstDigit, answerSecondDigit, multiplicationEx, equalityEx]
        ]
    }
    
    func configureImages() {
        backgroundImage.image = SVGKImage(named: "x23background").uiImage
        let gooseColor = Game.current.getColor(forDigit: 2)
        let sparrowColor = Game.current.getColor(forDigit: 3)
        firstDigit.image = SVGKImage(named: "x232" + gooseColor.rawValue).uiImage
        secondDigit.image = SVGKImage(named: "x233" + sparrowColor.rawValue).uiImage
        result.image = SVGKImage(named: "x23result").uiImage
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [
            [backgroundImage, firstDigit, secondDigit, result], 
            [firstDigitEx, secondDigitEx, secondDigitEx2, answerFirstDigit, answerSecondDigit, multiplicationEx, equalityEx]
        ]
    }
    
    func nextScreen() {
        globalStagePassing.updateElapsedTime()
        let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        vc.mode = .afterPermutationTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
}
