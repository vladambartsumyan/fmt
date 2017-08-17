import UIKit
import SVGKit

class IntroductionDigitVC: FadeInOutVC, IsGameVC {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var variantButton1: VariantButton!
    @IBOutlet weak var variantButton2: VariantButton!
    @IBOutlet weak var variantButton3: VariantButton!
    @IBOutlet weak var variantButton4: VariantButton!
    
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var digitImageView: UIImageView!
    
    var globalStagePassing: GlobalStagePassing!
    
    var mode: StageMode!
    
    var exercise: Exercise!
    
    var newGameWasPressed = false
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLevel()
        configureQuestion()
        configureTopBar()
        configureVariantPanel()
        configureImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            SoundHelper.shared.playVoice(name: "whatnumberis\(self.exercise.firstDigit)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SoundHelper.shared.stopVoice()
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
    
    func configureQuestion() {
        question.text = NSLocalizedString("Number.Introduction.Question.\(exercise.firstDigit)", comment: "")
    }
    
    func configureTopBar() {
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
    }
    
    func configureVariantPanel() {
        var allDigits = Game.current.introductionDigits
        let variantButtons = [variantButton1!, variantButton2!, variantButton3!, variantButton4!]
        let i = Int.random(min: 0, max: 3)
        variantButtons[i].setTitle(titleText: "\(exercise.firstDigit)")
        variantButtons[i].isWrongAnswer = false
        allDigits.remove(at: allDigits.index(of: exercise.firstDigit)!)
        for ind in 0..<variantButtons.count {
            if ind == i {
                continue
            }
            let variant = allDigits.randomElem()!
            allDigits.remove(at: allDigits.index(of: variant)!)
            variantButtons[ind].setTitle(titleText: "\(variant)")
        }
    }
    
    func configureImage() {
        background.image = SVGKImage(named: "background").uiImage
        if globalStagePassing.currentStagePassing!.stage.mode == .exam {
            let color = Game.current.getColor(forDigit: exercise.firstDigit)
            animalImageView.image = UIImage(named: "\(exercise.firstDigit)\(color.rawValue)")
        } else {
            animalImageView.image = SVGKImage(named: "\(exercise.firstDigit)" + "clear").uiImage
        }        
        digitImageView.image = mode == .exam ? nil : SVGKImage(named: "\(exercise.firstDigit)").uiImage
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[animalImageView, digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed || self.mode == .exam {
            return [[animalImageView, digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]
        }
        return [[digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]
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
            let vc = TutorialVC(nibName: "TutorialVC", bundle: nil)
            Game.current.reset()
            self.fadeOut {
                AppDelegate.current.setRootVC(vc)
            }
        }
        self.present(alert, animated: true, completion: nil)  
    }
    
    @IBAction func variantTouchUpInside(_ sender: VariantButton) {
        let isExam = self.mode == .exam
        if !sender.isWrongAnswer {
            globalStagePassing.updateElapsedTime()
            if isExam {
                GAManager.track(action: .introductionExamRightAnswer(digit: exercise.firstDigit), with: .game)
                progressBar.setProgressWithAnimation(CGFloat(globalStagePassing.nextProgress))
                let result = globalStagePassing.rightAnswerResult
                globalStagePassing.rightAnswer()
                var vc: UIViewController!
                switch result {
                case .endOfGlobalStage:
                    GAManager.track(action: .levelExamFinished(level: .introduction), with: .game)
                    let inBetweenVC = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
                    inBetweenVC.globalStagePassing = globalStagePassing
                    inBetweenVC.mode = .introductionExamPassed
                    vc = inBetweenVC
                    break
                case .endOfStage:
                    GAManager.track(action: .levelFinished(level: .introduction), with: .game)
                    GAManager.track(action: .levelExamStart(level: .introduction), with: .game)
                    let inBetweenVC = InBetweenVC(nibName: "InBetweenVC", bundle: nil)        
                    inBetweenVC.globalStagePassing = self.globalStagePassing  
                    inBetweenVC.mode = .beforeIntroductionExam
                    vc = inBetweenVC
                    break
                case .normal:
                    let introductionDigitVC = IntroductionDigitVC(nibName: "IntroductionDigitVC", bundle: nil)        
                    introductionDigitVC.globalStagePassing = self.globalStagePassing
                    vc = introductionDigitVC
                    break
                }
                fadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            } else {
                GAManager.track(action: .introductionRightAnswer(digit: exercise.firstDigit), with: .game)
                let vc = IntroductionColorVC(nibName: "IntroductionColorVC", bundle: nil)
                vc.globalStagePassing = self.globalStagePassing
                fadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            }
        } else {
            if isExam {
                globalStagePassing.updateElapsedTime()
                GAManager.track(action: .introductionExamMistake(digit: exercise.firstDigit), with: .game)
                let result = globalStagePassing.mistake()
                switch result {
                case .normal:
                    let vc = IntroductionDigitVC(nibName: "IntroductionDigitVC", bundle: nil)
                    vc.globalStagePassing = self.globalStagePassing
                    fadeOut {
                        AppDelegate.current.setRootVC(vc)
                    }
                    break
                case .soMuch:
                    GAManager.track(action: .levelRestart(level: .introduction), with: .game)
                    globalStagePassing.reset()
                    let inBetweenVC = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
                    inBetweenVC.mode = .introductionExamFailed
                    inBetweenVC.globalStagePassing = self.globalStagePassing       
                    fadeOut {
                        AppDelegate.current.setRootVC(inBetweenVC)
                    }
                    break
                }
            } else {
                _ = globalStagePassing.mistake()
                GAManager.track(action: .introductionMistake(digit: exercise.firstDigit), with: .game)
            }
        }
    }
}




