import UIKit

class IntroductionDigitVC: FadeInOutVC, IsGameVC {
    
    @IBOutlet weak var question: UILabel!
    
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
    
    var isGameViewController: Bool {
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
        fadeIn()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        progressBar.progress = CGFloat(Game.current.currentGlobalStagePassing.progress)
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
        let color = Game.current.getColor(forDigit: exercise.firstDigit)
        animalImageView.image = UIImage.init(named: "\(exercise.firstDigit)\(color.rawValue)")
        digitImageView.image = UIImage.init(named: "\(exercise.firstDigit)")
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
    
    @IBAction func variantTouchUpInside(_ sender: VariantButton) {
        let isExam = self.mode == .exam
        if !sender.isWrongAnswer {
            if isExam {
                progressBar.setProgressWithAnimation(CGFloat(globalStagePassing.nextProgress))
                let result = globalStagePassing.rightAnswer()
                var vc: UIViewController!
                switch result {
                case .endOfGlobalStage:
                    let inBetweenVC = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
                    inBetweenVC.mode = .introductionExamPassed
                    vc = inBetweenVC
                    break
                case .endOfStage:
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
                let vc = IntroductionColorVC(nibName: "IntroductionColorVC", bundle: nil)
                vc.globalStagePassing = self.globalStagePassing
                fadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            }
        } else {
            let result = globalStagePassing.mistake()
            switch result {
            case .normal:
                if isExam {
                    let vc = IntroductionDigitVC(nibName: "IntroductionDigitVC", bundle: nil)
                    vc.globalStagePassing = self.globalStagePassing
                    fadeOut {
                        AppDelegate.current.setRootVC(vc)
                    }
                }
                break
            case .soMuch:
                globalStagePassing.reset()
                if isExam {
                    let inBetweenVC = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
                    inBetweenVC.mode = .introductionExamFailed
                    inBetweenVC.globalStagePassing = self.globalStagePassing       
                    fadeOut {
                        AppDelegate.current.setRootVC(inBetweenVC)
                    }
                    break
                }
            }
            
            
        }
    }
}




