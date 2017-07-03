import UIKit

class ExerciseVC: FadeInOutVC, IsGameVC {

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
    
    // Exercise
    @IBOutlet weak var firstDigitEx: UIImageView!
    @IBOutlet weak var multiplicationEx: UIImageView!
    @IBOutlet weak var secondDigitEx: UIImageView!
    @IBOutlet weak var equalityEx: UIImageView!
    @IBOutlet weak var answerFirstDigit: UIImageView!
    @IBOutlet weak var answerSecondDigit: UIImageView!
    @IBOutlet weak var questionMark: UIImageView!
    
    var exercise: Exercise!
    var globalStagePassing: GlobalStagePassing!
    var mode: StageMode!
    
    @IBOutlet weak var answerSecondDigitExWidthToFirstDigitExWidth: NSLayoutConstraint!
    @IBOutlet weak var answerSecondDigitExWidth: NSLayoutConstraint!
    
    var newGameWasPressed = false
    
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
        fadeIn()
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
        progressBar.progress = CGFloat(globalStagePassing.progress)
    }
    
    @IBAction func menuTouchUpInside(_ sender: LeapingButton) {
        self.view.isUserInteractionEnabled = false
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        (UIApplication.shared.delegate as! AppDelegate).setRootVCWithAnimation(vc, animation: .transitionFlipFromLeft)
    }
    
    @IBAction func newGameTouchUpInside(_ sender: LeapingButton) {
        let alert = AlertMaker.newGameAlert {
            self.view.isUserInteractionEnabled = false
            self.newGameWasPressed = true
            let vc = TutorialVC(nibName: "TutorialVC", bundle: nil)
            Game.current.reset()
            self.fadeOut {
                (UIApplication.shared.delegate as! AppDelegate).setRootVC(vc)
            }
        }
        self.present(alert, animated: true, completion: nil)      
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[firstDigitEx, multiplicationEx, secondDigitEx, equalityEx, questionMark], 
                [firstVariant, secondVariant, thirdVariant, fourthVariant]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed {
            return [[background, firstDigit, secondDigit, result], 
                    [firstDigitEx, multiplicationEx, secondDigitEx, equalityEx, questionMark], 
                    [firstVariant, secondVariant, thirdVariant, fourthVariant]]
        }
        return [[background, firstDigit, secondDigit, result], 
                [firstDigitEx, multiplicationEx, secondDigitEx, equalityEx, answerFirstDigit, answerSecondDigit, questionMark], 
                [firstVariant, secondVariant, thirdVariant, fourthVariant]]
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
    
    func configureVariantPanel() {
        let result = exercise.firstDigit * exercise.secondDigit
        var allVariants: [Int] = []
        for varinat in max(result - 10, 0)...(result + 10) {
            allVariants.append(varinat)
        }
        let variantButtons = [firstVariant!, secondVariant!, thirdVariant!, fourthVariant!]
        let rightIndex = Int.random(min: 0, max: 3)
        let rightVariant = variantButtons[rightIndex]
        rightVariant.setTitle(titleText: "\(result)")
        rightVariant.isWrongAnswer = false
        allVariants.remove(at: allVariants.index(of: result)!)
        for button in variantButtons {
            if button == rightVariant {
                continue
            }
            let variant = allVariants.randomElem()!
            allVariants.remove(at: allVariants.index(of: variant)!)
            button.setTitle(titleText: "\(variant)")
        }
    }
    
    func configureExercise() {
        let res = exercise.firstDigit * exercise.secondDigit
        if res >= 10 {
            answerFirstDigit.image = UIImage.init(named: "\(Int(res / 10))exercise")
            answerSecondDigit.image = UIImage.init(named: "\(res % 10)exercise")
            answerSecondDigitExWidthToFirstDigitExWidth.priority = 1000
            answerSecondDigitExWidth.priority = 999
        } else {
            answerFirstDigit.image = UIImage.init(named: "\(res)exercise")
            answerSecondDigitExWidthToFirstDigitExWidth.priority = 999
            answerSecondDigitExWidth.priority = 1000
        }
        firstDigitEx.image = UIImage.init(named: "\(exercise.firstDigit)exercise")
        secondDigitEx.image = UIImage.init(named: "\(exercise.secondDigit)exercise")
    }
    
    @IBAction func variantTouchUpInside(_ sender: VariantButton) {
        if !sender.isWrongAnswer {
            self.view.isUserInteractionEnabled = false
            rightAnswerAppearing { self.nextScreen() }
        } else {
            let specialLevel = ([StageType.multiplicationBy0, .multiplicationBy1, .multiplicationBy10].contains(globalStagePassing.type))
            let result = globalStagePassing.mistake()
            if mode == .exam {
                if result == .normal {
                    if !specialLevel {
                        let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
                        vc.globalStagePassing = globalStagePassing
                        fadeOut {
                            AppDelegate.current.setRootVC(vc)
                        }
                    } else {
                        let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                        vc.globalStagePassing = globalStagePassing
                        vc.skipSecondDigit = true
                        fadeOut {
                            AppDelegate.current.setRootVC(vc)
                        }
                    } 
                }
                if result == .soMuch {
                    globalStagePassing.reset()
                    let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
                    vc.globalStagePassing = globalStagePassing
                    vc.mode = examFailedMode
                    AppDelegate.current.setRootVC(vc)
                }
            }
        }
    }
    
    func rightAnswerAppearing(_ handler: @escaping (()) -> ()) {
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: 0.0, y: 40.0)
        t = t.scaledBy(x: 0.5, y: 1.0)
        self.answerFirstDigit.alpha = 0.0
        self.answerSecondDigit.alpha = 0.0
        answerFirstDigit.isHidden = false
        answerSecondDigit.isHidden = false
        answerFirstDigit.transform = t
        answerSecondDigit.transform = t
        UIView.animate(withDuration: 0.2, animations: { 
            self.answerFirstDigit.transform = CGAffineTransform.identity
            self.answerSecondDigit.transform = CGAffineTransform.identity
            self.questionMark.alpha = 0.0
            self.answerFirstDigit.alpha = 1.0
            self.answerSecondDigit.alpha = 1.0
        }) { (_) in
            handler()
        }
    }
    
    func nextScreen() {
        let specialLevel = ([StageType.multiplicationBy0, .multiplicationBy1, .multiplicationBy10].contains(globalStagePassing.type))
        progressBar.setProgressWithAnimation(CGFloat(globalStagePassing.nextProgress))
        let result = globalStagePassing.rightAnswer()
        switch result {
        case .normal:
            if !specialLevel {
                let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                fadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                fadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            } 
            break    
        case .endOfStage:
            let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            vc.mode = beforeExamMode
            fadeOut {
                AppDelegate.current.setRootVC(vc)
            }
            break
        case .endOfGlobalStage:
            let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            vc.mode = afterExamMode
            fadeOut {
                AppDelegate.current.setRootVC(vc)
            }
            break
        }
    }
    
    var isGameViewController: Bool {
        return true
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
        default:
            fatalError()
        }
    }
    
    var afterExamMode: InBetweenMode {
        let type = globalStagePassing.type
        switch type {
        case .introduction:
            fatalError("Unexpected introduction level in ExerciseVC")
        case .multiplicationBy0:
            return .multByZeroExamPassed
        case .multiplicationBy1:
            return .multByOneExamPassed
        default:
            fatalError()
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
        default:
            fatalError()
        }
    }
}
