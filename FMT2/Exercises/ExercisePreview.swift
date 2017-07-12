import UIKit

class ExercisePreview: FadeInOutVC, IsGameVC {
    
    // Top bar
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    // Images
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var result: UIImageView!
    
    // Text
    @IBOutlet weak var textLabel: UILabel!
    
    // Button
    @IBOutlet weak var continueButton: TextButton!
    
    // Level
    var exercise: Exercise!
    var globalStagePassing: GlobalStagePassing!
    var mode: StageMode!
    
    var newGameWasPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLevel()
        configureTopBar()
        configureImages()
        configureText()
        configureButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        globalStagePassing.updateElapsedTime()
    }
    
    func configureImages() {
        let fst = min(exercise.firstDigit, exercise.secondDigit)
        let snd = max(exercise.firstDigit, exercise.secondDigit)
        let reverseImage = ReverseImageOrder.check(firstDigit: fst, secondDigit: snd)
        let s1: String
        let s2: String
        let c1: String
        let c2: String
        let s: String
        if !reverseImage {
            s1 = "\(fst)"
            s2 = "\(snd)"
            s = "x" + s1 + s2
            c1 = Game.current.getColor(forDigit: fst).rawValue
            c2 = Game.current.getColor(forDigit: snd).rawValue
        } else {
            s1 = "\(snd)"
            s2 = "\(fst)"
            s = "x" + s2 + s1
            c1 = Game.current.getColor(forDigit: snd).rawValue
            c2 = Game.current.getColor(forDigit: fst).rawValue
        }
        background.image = UIImage.init(named: s + "background")
        firstDigit.image = UIImage.init(named: s + s1 + c1)
        secondDigit.image = UIImage.init(named: s + s2 + c2)
        result.image = self.mode == .exam ? nil : UIImage.init(named: s + "result")
    }
    
    func configureButton() {
        continueButton.setTitle(titleText: NSLocalizedString("Button.next", comment: ""))
    }
    
    func configureLevel() {
        if globalStagePassing == nil {
            globalStagePassing = Game.current.currentGlobalStagePassing
        }
        self.exercise = globalStagePassing.currentStagePassing!.currentExercisePassing!.exercise
        self.mode = globalStagePassing.currentStagePassing!.stage.mode
    }
    
    func configureText() {
        let keys: (Int, Int) = globalStagePassing.type == .permutation ? (exercise.secondDigit, exercise.firstDigit) : (exercise.firstDigit, exercise.secondDigit)
        textLabel.text = NSLocalizedString("Preview.Exercise.Text.\(keys.0)\(keys.1)", comment: "")
    }
    
    func configureTopBar() {
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
    }
    
    @IBAction func menuTouchUpInside(_ sender: LeapingButton) {
        self.view.isUserInteractionEnabled = false
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        AppDelegate.current.setRootVCWithAnimation(vc, animation: .transitionFlipFromLeft)
    }
    
    @IBAction func newGameTouchUpInside(_ sender: LeapingButton) {    
        let alert = AlertMaker.newGameAlert {
            self.view.isUserInteractionEnabled = false
            self.newGameWasPressed = true
            let vc = TutorialVC(nibName: "TutorialVC", bundle: nil)
            Game.current.reset()
            self.fadeOut {
                AppDelegate.current.setRootVC(vc)
            }
        }
        self.present(alert, animated: true, completion: nil) 
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[background, firstDigit, secondDigit, result], [textLabel], [continueButton]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed {
            return [[background, firstDigit, secondDigit, result], [textLabel], [continueButton]]
        }
        return [[textLabel], [continueButton]]
    }
    
    @IBAction func continueButtonTouchUpInside(_ sender: TextButton) {
        self.view.isUserInteractionEnabled = false
        let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
        vc.globalStagePassing = globalStagePassing
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }   
    
    func reverseImage(firstDigit: Int, secondDigit: Int) -> Bool {
        return [(4, 7), (7, 4)].reduce(false){ $0.0 || ($0.1.0 == firstDigit && $0.1.1 == secondDigit) }
    }
}
