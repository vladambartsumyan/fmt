import UIKit
import SVGKit

class IntroductionZeroVC: FadeInOutVC, IsGameVC {
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var variantButton1: VariantButton!
    @IBOutlet weak var variantButton2: VariantButton!
    @IBOutlet weak var variantButton3: VariantButton!
    @IBOutlet weak var variantButton4: VariantButton!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    @IBOutlet weak var skipButton: TextButton!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var digitImageView: UIImageView!
    
    var needTutorial = true
    
    var digitGuessed = false
    
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
        configureImage()
        configureSkipButton()
        configureVariantPanel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            self.whatIsNumberHat()
        }
    }
    
    func whatIsNumberHat() {
        SoundHelper.shared.playVoice(name: "multiplicationBy0begin")
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
        question.text = NSLocalizedString("Number.Introduction.Question.0", comment: "")
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
        variantButtons[i].setTitle(titleText: "0")
        variantButtons[i].isWrongAnswer = false
        allDigits.remove(at: allDigits.index(of: 0)!)
        for ind in 0..<variantButtons.count {
            if ind == i {
                continue
            }
            let variant = allDigits.randomElem()!
            allDigits.remove(at: allDigits.index(of: variant)!)
            variantButtons[ind].setTitle(titleText: "\(variant)")
        }
    }
    
    func configureSkipButton() {
        let title = NSLocalizedString("SkipButton.title", comment: "")
        skipButton.setTitle(titleText: title)
        skipButton.isEnabled = false
        skipButton.alpha = 0.0
    }
    
    func configureImage() {
        background.image = SVGKImage(named: "background").uiImage
        let color = Game.current.getColor(forDigit: 0)
        animalImageView.image = UIImage(named: "0\(color.rawValue)")
        digitImageView.image = SVGKImage.init(named: "0").uiImage
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[animalImageView, digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if needTutorial {
            return [[animalImageView, digitImageView], [question]]
        } else {
            return [[animalImageView, digitImageView], [question], [skipButton]]
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
    
    @IBAction func variantTouchUpInside(_ sender: VariantButton) {
        if !sender.isWrongAnswer {
            digitGuessed = true
            fadeOut(array: [[digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]) {
                
                self.question.transform = .identity
                self.question.text = NSLocalizedString("Tutorial.zero.text", comment: "")
                self.fadeInView(self.question)
                
                self.skipButton.isEnabled = true
                self.fadeInView(self.skipButton)
                
                let tutorial1Duration = SoundHelper.shared.duration(self.globalStagePassing.type.string + "tutorial1")
                let tutorial2Duration = SoundHelper.shared.duration(self.globalStagePassing.type.string + "tutorial2")
                
                self.perform(#selector(self.play), with: self.globalStagePassing.type.string + "tutorial1", afterDelay: 0)
                self.perform(#selector(self.play), with: self.globalStagePassing.type.string + "tutorial2", afterDelay: tutorial1Duration)
                self.perform(#selector(self.nextVC), with: nil, afterDelay: tutorial1Duration + tutorial2Duration)
            }
        }
    }
    
    @objc func play(name: String) {
        guard needTutorial else { return }
        SoundHelper.shared.playVoice(name: name)
    }
    
    @objc func nextVC() {
        guard needTutorial else { return }
        globalStagePassing.updateElapsedTime()
        let vc = MultByZeroExampleVC(nibName: "MultByZeroExampleVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
    
    func skipTutorial() {
        needTutorial = false
        SoundHelper.shared.stopVoice()
        globalStagePassing.updateElapsedTime()
        let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        vc.mode = .afterZeroTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
    
    @IBAction func skipButtonAction(_ sender: TextButton) {
        skipTutorial()
    }
}




