import UIKit
import SVGKit
class ExercisePreview: FadeInOutVC, IsGameVC {
    
    // Top bar
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    // Images
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var result: UIImageView!
    
    // Text
    @IBOutlet weak var textLabel: UILabel!
    
    // Button
    @IBOutlet weak var continueButton: TextButton!
    
    var timer: Timer? = nil
    
    // Level
    var exercise: Exercise!
    var globalStagePassing: GlobalStagePassing!
    var mode: StageMode!
    
    var newGameWasPressed = false
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
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
        fadeIn {
            let preview1Name = self.globalStagePassing.type == .permutation ? "x\(self.exercise.secondDigit)\(self.exercise.firstDigit)-2" : "x\(self.exercise.firstDigit)\(self.exercise.secondDigit)-2"
            let duration1 = SoundHelper.shared.duration(preview1Name)
            self.perform(#selector(self.play), with: preview1Name, afterDelay: 0)
            self.timer = Timer.scheduledTimer(timeInterval: duration1, target: self, selector: #selector(self.playPreview2), userInfo: nil, repeats: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SoundHelper.shared.stopVoice()
        timer?.invalidate()
        timer = nil
    }
    
    func configureImages() {
        background.image = SVGKImage(named: "background").uiImage
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
        backgroundImage.image = SVGKImage(named: s + "background").uiImage
        firstDigit.image = SVGKImage(named: s + s1 + c1).uiImage
        secondDigit.image = SVGKImage(named: s + s2 + c2).uiImage
        result.image = self.mode == .exam ? nil : SVGKImage(named: s + "result").uiImage
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
        if globalStagePassing._type == StageType.training.rawValue {
            progressBar.alpha = 0
        } else {
            progressBar.progress = CGFloat(globalStagePassing.progress)
        }
    }
    
    @IBAction func menuTouchUpInside(_ sender: LeapingButton) {
        GAManager.track(action: .levelExit(level: StageType(rawValue: (globalStagePassing._type))!), with: .game)
        self.view.isUserInteractionEnabled = false
        SoundHelper.shared.stopVoice()
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        self.globalStagePassing.updateElapsedTime()
        AppDelegate.current.setRootVCWithAnimation(vc, animation: .transitionFlipFromLeft)
    }
    
    @IBAction func newGameTouchUpInside(_ sender: LeapingButton) {    
        let alert = AlertMaker.newGameAlert {
            self.view.isUserInteractionEnabled = false
            self.newGameWasPressed = true
            Game.current.reset()
            Game.current.createGame()
            let vc = StageMapVC(nibName: "StageMapVC", bundle: nil)
            self.fadeOut {
                AppDelegate.current.setRootVC(vc)
            }
        }
        self.present(alert, animated: true, completion: nil) 
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[backgroundImage, firstDigit, secondDigit, result], [textLabel], [continueButton]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed {
            return [[backgroundImage, firstDigit, secondDigit, result], [textLabel], [continueButton]]
        }
        return [[textLabel], [continueButton]]
    }
    
    @IBAction func continueButtonTouchUpInside(_ sender: TextButton) {
        globalStagePassing.updateElapsedTime()
        self.view.isUserInteractionEnabled = false
        let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
        vc.globalStagePassing = globalStagePassing
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }   
    
    func reverseImage(firstDigit: Int, secondDigit: Int) -> Bool {
        return [(4, 7), (7, 4)].reduce(false){ $0 || ($1.0 == firstDigit && $1.1 == secondDigit) }
    }
    
    @objc func play(name: String) {
        SoundHelper.shared.playVoice(name: name)
    }
    @objc  
    func playPreview2() {
        let preview2Name = self.globalStagePassing.type == .permutation ? "x\(self.exercise.secondDigit)\(self.exercise.firstDigit)-3" : "x\(self.exercise.firstDigit)\(self.exercise.secondDigit)-3"
        play(name: preview2Name)
    }
}
