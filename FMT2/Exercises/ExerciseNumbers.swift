import UIKit
import SVGKit

class ExerciseNumbers: FadeInOutVC, IsGameVC {

    // Top bar
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    // Images
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var result: UIImageView!
    
    // Variants
    @IBOutlet weak var firstVariant: VariantButton!
    @IBOutlet weak var secondVariant: VariantButton!
    @IBOutlet weak var thirdVariant: VariantButton!
    @IBOutlet weak var fourthVariant: VariantButton!
    
    // Text
    @IBOutlet weak var textLabel: UILabel!
    
    var isSecondNumber = false
    var skipSecondDigit = false
    
    var newGameWasPressed = false
    
    var exercise: Exercise!
    var globalStagePassing: GlobalStagePassing!
    var mode: StageMode!
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLevel()
        configureTopBar()
        configureImages()
        configureText()
        configureVariantPanel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            let digit = self.isSecondNumber ? self.exercise.secondDigit : self.exercise.firstDigit
            SoundHelper.shared.playVoice(name: "\(digit)isnumber")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureLevel() {
        if globalStagePassing == nil {
            globalStagePassing = Game.current.currentGlobalStagePassing
        }
        self.exercise = globalStagePassing.currentStagePassing!.currentExercisePassing!.exercise
        self.mode = globalStagePassing.currentStagePassing!.stage.mode
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
        self.view.isUserInteractionEnabled = false
        SoundHelper.shared.stopVoice()
        self.globalStagePassing.updateElapsedTime()
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        self.newGameWasPressed = true
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
        let needPreview = !([StageType.multiplicationBy0, .multiplicationBy1, .multiplicationBy10].contains(globalStagePassing.type))
        if needPreview {
            return [[textLabel], [firstVariant, secondVariant, thirdVariant, fourthVariant]]
        } else {
            return [[background, firstDigit, secondDigit, result], [textLabel], [firstVariant, secondVariant, thirdVariant, fourthVariant]]
        }
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed {
           return [[background, firstDigit, secondDigit, result], [textLabel], [firstVariant, secondVariant, thirdVariant, fourthVariant]]
        }
        return [[textLabel], [firstVariant, secondVariant, thirdVariant, fourthVariant]]
    }

    func configureImages() {
        if globalStagePassing.type == .multiplicationBy0 {
            let mult = max(exercise.firstDigit, exercise.secondDigit)
            let multColor = Game.current.getColor(forDigit: mult)
            firstDigit.image = SVGKImage(named: "\(mult)\(multColor.rawValue)").uiImage
            background.image = nil
            secondDigit.image = nil
            result.image = nil
            return
        }
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
            s = globalStagePassing.type == .multiplicationBy1 ? "x" + s2 + s1 : "x" + s1 + s2
            c1 = Game.current.getColor(forDigit: fst).rawValue
            c2 = Game.current.getColor(forDigit: snd).rawValue
        } else {
            s1 = "\(snd)"
            s2 = "\(fst)"
            s = "x" + s2 + s1
            c1 = Game.current.getColor(forDigit: snd).rawValue
            c2 = Game.current.getColor(forDigit: fst).rawValue
        }
        background.image = SVGKImage(named: s + "background").uiImage
        firstDigit.image = SVGKImage(named: s + s1 + c1).uiImage
        secondDigit.image = SVGKImage(named: s + s2 + c2).uiImage
        result.image = self.mode == .exam ? nil : SVGKImage(named: s + "result").uiImage
    }
    
    func configureText() {
        let digit = isSecondNumber ? exercise.secondDigit : exercise.firstDigit
        textLabel.text = NSLocalizedString("Numbers.Exercise.Text.\(digit)", comment: "")
    }
    
    func configureVariantPanel() {
        var allDigits = Game.current.introductionDigits
        let variantButtons = [firstVariant!, secondVariant!, thirdVariant!, fourthVariant!]
        let i = Int.random(min: 0, max: 3)
        let digit = isSecondNumber ? exercise.secondDigit : exercise.firstDigit
        variantButtons[i].setTitle(titleText: "\(digit)")
        variantButtons[i].isWrongAnswer = false
        if let index = allDigits.index(of: digit) {
            allDigits.remove(at: index)
        }
        for ind in 0..<variantButtons.count {
            if ind == i {
                continue
            }
            let variant = allDigits.randomElem()!
            allDigits.remove(at: allDigits.index(of: variant)!)
            variantButtons[ind].setTitle(titleText: "\(variant)")
        }
    }
    
    @IBAction func variantTouchUpInside(_ sender: VariantButton) {
        let duration = sender.voiceDuration
        globalStagePassing.updateElapsedTime()
        if !sender.isWrongAnswer {
            self.view.isUserInteractionEnabled = false
            if !isSecondNumber && exercise.firstDigit != exercise.secondDigit && !skipSecondDigit {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.isSecondNumber = true
                perform(#selector(nextScreen), with: vc, afterDelay: duration)
            } else {
                let vc = ExerciseVC(nibName: "ExerciseVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                perform(#selector(nextScreen), with: vc, afterDelay: duration)
            }
        }
    }
    
    func nextScreen(viewController: UIViewController) {
        fadeOut {
            AppDelegate.current.setRootVC(viewController)
        }
    }
}
