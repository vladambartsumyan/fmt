import UIKit
import SVGKit

class MultByTenExampleVC: FadeInOutVC, IsGameVC {
    
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
    
    @IBOutlet weak var skipButton: TextButton!
    
    var needTutorial = true
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExerciseSize()
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
        configureImage()
        configureSkipButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            let exampleName = StageType.multiplicationBy10.string + "example"
            let exampleDuration = SoundHelper.shared.duration(exampleName)
            SoundHelper.shared.playVoice(name: exampleName)
            self.perform(#selector(self.nextScreen), with: nil, afterDelay: exampleDuration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalStagePassing.updateElapsedTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureImage() {
        background.image = SVGKImage(named: "background").uiImage
        let gooseColor = Game.current.getColor(forDigit: 2)
        self.firstDigit.image = SVGKImage.init(named: "x2102" + gooseColor.rawValue).uiImage
    }
    
    func configureSkipButton() {
        let title = NSLocalizedString("SkipButton.title", comment: "")
        skipButton.setTitle(titleText: title)
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
            [backgroundImage, firstDigit, secondDigit, result], 
            [firstDigitEx, secondDigitEx, secondDigitEx2, answerFirstDigit, answerSecondDigit, multiplicationEx, equalityEx],
            [skipButton]
        ]
    }
    
    @objc func nextScreen() {
        guard needTutorial else { return }
        needTutorial = false
        globalStagePassing.updateElapsedTime()
        let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        vc.mode = .afterTenTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
    
    @IBAction func skipButtonAction(_ sender: TextButton) {
        SoundHelper.shared.stopVoice()
        nextScreen()
    }
    
}
