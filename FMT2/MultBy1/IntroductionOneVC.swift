import UIKit

class IntroductionOneVC: FadeInOutVC, IsGameVC {
    
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
    
    var digitGuessed = false
    
    var globalStagePassing: GlobalStagePassing!
    
    var mode: StageMode!
    
    var exercise: Exercise!
    
    var newGameWasPressed = false
    
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
        question.text = NSLocalizedString("Number.Introduction.Question.1", comment: "")
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
        variantButtons[i].setTitle(titleText: "1")
        variantButtons[i].isWrongAnswer = false
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
        let color = Game.current.getColor(forDigit: 1)
        animalImageView.image = UIImage.init(named: "1\(color.rawValue)")
        digitImageView.image = UIImage.init(named: "1")
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[animalImageView, digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed {
            return digitGuessed ? 
                [[animalImageView, digitImageView], [question]] :
                [[animalImageView, digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]
        }
        return [[animalImageView], [question]]
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
        if !sender.isWrongAnswer {
            digitGuessed = true
            fadeOut(array: [[digitImageView], [question], [variantButton1, variantButton2, variantButton3, variantButton4]]) {
                self.question.transform = .identity
                self.question.text = NSLocalizedString("Tutorial.one.text", comment: "")
                self.fadeInView(self.question)
                self.perform(#selector(self.nextVC), with: nil, afterDelay: 4)
            }
        }
    }
    
    func nextVC() {
        let vc = MultByOneExampleVC(nibName: "MultByOneExampleVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
    
}




