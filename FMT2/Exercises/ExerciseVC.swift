import UIKit
import SVGKit

class ExerciseVC: FadeInOutVC, IsGameVC {

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

    // Variants
    @IBOutlet weak var firstVariant: VariantButton!
    @IBOutlet weak var secondVariant: VariantButton!
    @IBOutlet weak var thirdVariant: VariantButton!
    @IBOutlet weak var fourthVariant: VariantButton!

    // Exercise
    @IBOutlet weak var fst1: UIImageView!
    @IBOutlet weak var fst2: UIImageView!
    @IBOutlet weak var mult: UIImageView!
    @IBOutlet weak var snd1: UIImageView!
    @IBOutlet weak var snd2: UIImageView!
    @IBOutlet weak var equality: UIImageView!
    @IBOutlet weak var res1: UIImageView!
    @IBOutlet weak var res2: UIImageView!
    @IBOutlet weak var question: UIImageView!

    let digitWidth = 40.0 * UIScreen.main.bounds.width / 414.0
    let signWidth = 30.0 * UIScreen.main.bounds.width / 414.0

    var exercise: Exercise!
    var globalStagePassing: GlobalStagePassing!
    var mode: StageMode!

    @IBOutlet weak var fst2width: NSLayoutConstraint!
    @IBOutlet weak var fst1width: NSLayoutConstraint!
    @IBOutlet weak var snd2width: NSLayoutConstraint!
    @IBOutlet weak var snd1width: NSLayoutConstraint!
    @IBOutlet weak var res2width: NSLayoutConstraint!
    @IBOutlet weak var res1width: NSLayoutConstraint!
    @IBOutlet weak var mulWidth: NSLayoutConstraint!
    @IBOutlet weak var eqWidth: NSLayoutConstraint!
    @IBOutlet weak var questionWidth: NSLayoutConstraint!

    var newGameWasPressed = false

    override var needsToTimeAccumulation: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLevel()
        configureTopBar()
        configureImages()
        configureExercise()
        configureVariantPanel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            SoundHelper.shared.playVoice(name: "x\(self.exercise.firstDigit)\(self.exercise.secondDigit)-1")
        }
        if self.globalStagePassing.type == .multiplicationBy0 {
            self.secondDigit.transform = CGAffineTransform.init(translationX: 0, y: -self.secondDigit.frame.height)
            self.result.transform = CGAffineTransform.init(translationX: 0, y: -self.secondDigit.frame.height)
            UIView.animate(withDuration: 0.8) {
                self.secondDigit.transform = .identity
                self.secondDigit.alpha = 1.0
                self.result.transform = .identity
                self.result.alpha = 1.0
            }
            UIView.animate(withDuration: 0.3, delay: 0.5, animations: {
                self.firstDigit.alpha = 0.0
            })
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
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        self.globalStagePassing.updateElapsedTime()
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
        return [[fst1, fst2, snd1, snd2, question, equality, mult],
                [firstVariant, secondVariant, thirdVariant, fourthVariant]]
    }

    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed {
            return [[backgroundImage, firstDigit, secondDigit, result],
                    [fst1, fst2, snd1, snd2, question, equality, mult, res1, res2],
                    [firstVariant, secondVariant, thirdVariant, fourthVariant]]
        }
        return [[backgroundImage, firstDigit, secondDigit, result],
                [fst1, fst2, snd1, snd2, question, equality, mult, res1, res2],
                [firstVariant, secondVariant, thirdVariant, fourthVariant]]
    }

    func configureImages() {
        background.image = SVGKImage(named: "background").uiImage
        if globalStagePassing.type == .multiplicationBy0 {
            let mult = max(exercise.firstDigit, exercise.secondDigit)
            let multColor = Game.current.getColor(forDigit: mult)
            firstDigit.image = UIImage(named: "\(mult)\(multColor.rawValue)")

            let zeroColor = Game.current.getColor(forDigit: 0)
            secondDigit.image = UIImage(named: "\(0)\(zeroColor.rawValue)")
            secondDigit.alpha = 0.0

            result.image = mode == .exam ? nil : SVGKImage(named: "0").uiImage
            result.alpha = 0.0

            backgroundImage.image = nil
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
        backgroundImage.image = SVGKImage(named: s + "background").uiImage
        if globalStagePassing.type != .multiplicationBy1 {
            firstDigit.image = SVGKImage(named: s + s1 + c1).uiImage
        }
        if globalStagePassing.type != .multiplicationBy10 {
            secondDigit.image = SVGKImage(named: s + s2 + c2).uiImage
        }
        result.image = self.mode == .exam ? nil : SVGKImage(named: s + "result").uiImage
    }

    func configureVariantPanel() {
        let result = exercise.firstDigit * exercise.secondDigit
        var (variants, required) = exercise.allVariants
        var variantButtons = [firstVariant!, secondVariant!, thirdVariant!, fourthVariant!]
        
        let rightIndex = Int.random(min: 0, max: 3)
        let rightVariant = variantButtons[rightIndex]
        rightVariant.setTitle(titleText: "\(result)")
        rightVariant.isWrongAnswer = false
        variantButtons.remove(at: rightIndex)
        
        let requiredIndex = Int.random(min: 0, max: 2)
        let requiredVariant = variantButtons[requiredIndex]
        requiredVariant.setTitle(titleText: "\(required)")
        variantButtons.remove(at: requiredIndex)
        
        for button in variantButtons {
            let variant = variants.randomElem()!
            variants.remove(at: variants.index(of: variant)!)
            button.setTitle(titleText: "\(variant)")
        }
    }

    func configureExercise() {
        mulWidth.constant = signWidth
        eqWidth.constant = signWidth
        fst1width.constant = digitWidth
        snd1width.constant = digitWidth
        res1width.constant = digitWidth
        questionWidth.constant = digitWidth

        let res = exercise.firstDigit * exercise.secondDigit

        if exercise.firstDigit >= 10 {
            fst2width.constant = digitWidth
            fst1.image = UIImage(named: "\(Int(exercise.firstDigit / 10))exercise")
            fst2.image = UIImage(named: "\(exercise.firstDigit % 10)exercise")
        } else {
            fst2width.constant = 0.0
            fst1.image = UIImage(named: "\(exercise.firstDigit)exercise")
        }

        if exercise.secondDigit >= 10 {
            snd2width.constant = digitWidth
            snd1.image = UIImage(named: "\(Int(exercise.secondDigit / 10))exercise")
            snd2.image = UIImage(named: "\(exercise.secondDigit % 10)exercise")
        } else {
            snd2width.constant = 0.0
            snd1.image = UIImage(named: "\(exercise.secondDigit)exercise")
        }

        if res >= 10 {
            res2width.constant = digitWidth
            res1.image = UIImage(named: "\(Int(res / 10))exercise")
            res2.image = UIImage(named: "\(res % 10)exercise")
        } else {
            res2width.constant = 0.0
            res1.image = UIImage(named: "\(res)exercise")
        }

    }

    @IBAction func variantTouchUpInside(_ sender: VariantButton) {
        let duration = sender.voiceDuration
        if !sender.isWrongAnswer {
            self.view.isUserInteractionEnabled = false
            rightAnswerAppearing {
                self.nextScreen(duration)
            }
        } else {
            if mode == .exam {
                view.isUserInteractionEnabled = false
                globalStagePassing.updateElapsedTime()
                let result = globalStagePassing.mistake()
                let needPreview = !([StageType.multiplicationBy0, .multiplicationBy1, .multiplicationBy10].contains(globalStagePassing.type))
                if result == .normal {
                    if needPreview {
                        let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
                        vc.globalStagePassing = globalStagePassing
                        perform(#selector(nextVC), with: vc, afterDelay: duration)
                    } else {
                        let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                        vc.globalStagePassing = globalStagePassing
                        vc.skipSecondDigit = true
                        perform(#selector(nextVC), with: vc, afterDelay: duration)
                    }
                }
                if result == .soMuch {
                    globalStagePassing.reset()
                    let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
                    vc.globalStagePassing = globalStagePassing
                    vc.mode = examFailedMode
                    perform(#selector(nextVC), with: vc, afterDelay: duration)
                }
            } else {
                _ = globalStagePassing.mistake()
            }
        }
    }

    func rightAnswerAppearing(_ handler: @escaping (()) -> ()) {
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: 0.0, y: 40.0)
        t = t.scaledBy(x: 0.5, y: 1.0)
        self.res1.alpha = 0.0
        self.res2.alpha = 0.0
        res1.isHidden = false
        res2.isHidden = false
        res1.transform = t
        res2.transform = t
        UIView.animate(withDuration: 0.2, animations: {
            self.res1.transform = CGAffineTransform.identity
            self.res2.transform = CGAffineTransform.identity
            self.question.alpha = 0.0
            self.res1.alpha = 1.0
            self.res2.alpha = 1.0
        }) { (_) in
            handler()
        }
    }

    func nextScreen(_ duration: Double) {
        globalStagePassing.updateElapsedTime()
        progressBar.setProgressWithAnimation(CGFloat(globalStagePassing.nextProgress))
        let result = globalStagePassing.rightAnswerResult
        let specialLevels = [StageType.multiplicationBy0, .multiplicationBy1, .multiplicationBy10]
        var nextExerciseIsSpecial: Bool = false
        if let typeOfNextStage = globalStagePassing.typeOfNextExercise {
            nextExerciseIsSpecial = specialLevels.contains(typeOfNextStage)
        }
        globalStagePassing.rightAnswer()
        switch result {
        case .normal:
            if !nextExerciseIsSpecial {
                let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                perform(#selector(nextVC), with: vc, afterDelay: duration)
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                perform(#selector(nextVC), with: vc, afterDelay: duration)
            }
            break
        case .endOfStage:
            let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            vc.mode = beforeExamMode
            perform(#selector(nextVC), with: vc, afterDelay: duration)
            break
        case .endOfGlobalStage:
            let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            vc.mode = afterExamMode
            if globalStagePassing.type == .permutation {
                ServerTaskManager.pushBack(.exerciseFinished())
            }
            perform(#selector(nextVC), with: vc, afterDelay: duration)
            break
        }
    }

    var beforeExamMode: InBetweenMode {
        let type = globalStagePassing.type
        switch type {
        case .introduction:
            fatalError("Unexpected introduction level in ExerciseVC")
        case .multiplicationBy0:
            return .beforeMultByZeroExam
        case .multiplicationBy1:
            return .beforeMultByOneExam
        case .multiplicationBy10:
            return .beforeMultByTenExam
        default:
            return .beforeExam
        }
    }

    var afterExamMode: InBetweenMode {
        if globalStagePassing._type == StageType.training.rawValue {
            return .trainingPassed
        }
        let type = globalStagePassing.type
        switch type {
        case .introduction:
            fatalError("Unexpected introduction level in ExerciseVC")
        case .multiplicationBy0:
            return .multByZeroExamPassed
        case .multiplicationBy1:
            return .multByOneExamPassed
        case .multiplicationBy10:
            return .multByTenExamPassed
        case .permutation:
            return .permutationExamPassed
        default:
            return .examPassed
        }
    }

    var examFailedMode: InBetweenMode {
        let type = globalStagePassing.type
        switch type {
        case .introduction:
            fatalError("Unexpected introduction level in ExerciseVC")
        case .multiplicationBy0:
            return .multByZeroExamFailed
        case .multiplicationBy1:
            return .multByOneExamFailed
        case .multiplicationBy10:
            return .multByTenExamFailed
        case .permutation:
            return .permutationExamFailed
        default:
            return .examFailed
        }
    }
    
    func nextVC(viewController: UIViewController) {
        fadeOut {
            AppDelegate.current.setRootVC(viewController)
        }
    }
}
