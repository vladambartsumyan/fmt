import UIKit
import SVGKit
class IntroductionColorVC: FadeInOutVC, IsGameVC {
    
    var exercise: Exercise!
    
    var globalStagePassing: GlobalStagePassing!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var brownPencil: UIImageView!
    @IBOutlet weak var greenPencil: UIImageView!
    @IBOutlet weak var grayPencil: UIImageView!
    @IBOutlet weak var purplePencil: UIImageView!
    @IBOutlet weak var bluePencil: UIImageView!
    @IBOutlet weak var yellowPencil: UIImageView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var continueButton: TextButton!
    
    @IBOutlet weak var brownPencilImage: UIImageView!
    @IBOutlet weak var greenPencilImage: UIImageView!
    @IBOutlet weak var grayPencilImage: UIImageView!
    @IBOutlet weak var purplePencilImage: UIImageView!
    @IBOutlet weak var yellowPencilImage: UIImageView!
    @IBOutlet weak var bluePencilImage: UIImageView!
    
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    var selectedPencil: UIImageView? = nil
    
    var newGameWasPressed = false
    
    var colors: [String : UIImage] = [:]
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLevel()
        configureTopBar()
        configureImage()
        configureQuestion()
        configureContinueButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            SoundHelper.shared.playVoice(name: "whatcoloris\(self.exercise.firstDigit)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SoundHelper.shared.stopVoice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureLevel() {
        exercise = globalStagePassing.currentStagePassing!.currentExercisePassing!.exercise
    }
    
    func configureTopBar() {
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
    }
    
    func configureImage() {
        background.image = SVGKImage(named: "background").uiImage
        brownPencil.image = SVGKImage(named: "brown").uiImage
        greenPencil.image = SVGKImage(named: "green").uiImage
        purplePencil.image = SVGKImage(named: "purple").uiImage
        bluePencil.image = SVGKImage(named: "blue").uiImage
        yellowPencil.image = SVGKImage(named: "yellow").uiImage
        grayPencil.image = SVGKImage(named: "gray").uiImage
        image.image = SVGKImage(named: "\(exercise.firstDigit)clear").uiImage
    }
    
    func configureContinueButton() {
        continueButton.setTitle(titleText: NSLocalizedString("Button.next", comment: ""))
    }
    
    func configureQuestion() {
        label.text = NSLocalizedString("Color.Introduction.Question.\(exercise.firstDigit)", comment: "")
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[label], [brownPencilImage, greenPencilImage, grayPencilImage, purplePencilImage, yellowPencilImage, bluePencilImage]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        if newGameWasPressed {
            return [[image], [label], [brownPencilImage, greenPencilImage, grayPencilImage, purplePencilImage, yellowPencilImage, bluePencilImage]]
        }
        return [[image], [continueButton], [brownPencilImage, greenPencilImage, grayPencilImage, purplePencilImage, yellowPencilImage, bluePencilImage]]
    }
    
    @IBAction func pencilTapped(_ sender: UITapGestureRecognizer) {
        guard let attachedView = sender.view else {
            return
        }
        let attachedViewIsPencil = [brownPencilImage, greenPencilImage, grayPencilImage, purplePencilImage, yellowPencilImage, bluePencilImage].contains{ attachedView == $0 }
        guard attachedViewIsPencil && attachedView != selectedPencil else {
            return
        }
        
        animateSelectPencil(attachedView as! UIImageView)
        
        let colorString = self.pencilToColor(pencil: attachedView as? UIImageView).rawValue
        animateSetImage(withName: "\(exercise.firstDigit)\(colorString)")
    }
    
    
    func animateSetImage(withName name: String) {
        UIView.transition(with: image, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.image.image = UIImage(named: name)
        }, completion: nil)
    }
    
    func animateSelectPencil(_ pencil: UIImageView) {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            pencil.transform = CGAffineTransform.init(translationX: 0, y: -25)
            self.selectedPencil?.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }) { _ in
            if self.selectedPencil == nil {
                self.replaceLabelToButton()
            }
            self.selectedPencil = pencil
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func replaceLabelToButton() {
        self.continueButton.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.2) {
            self.label.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            self.label.alpha = 0.0
            self.continueButton.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self.continueButton.alpha = 1.0
        }
    }
    
    func pencilToColor(pencil: UIImageView?) -> Color {
        guard let pencil = pencil else {
            return .clear
        }
        switch pencil {
        case brownPencilImage:
            return .brown
        case greenPencilImage:
            return .green
        case grayPencilImage:
            return .gray
        case purplePencilImage:
            return .purple
        case yellowPencilImage:
            return .yellow
        case bluePencilImage:
            return .blue
        default:
            return .clear
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
    
    @IBAction func continueButtonTouchUpInside(_ sender: TextButton) {
        globalStagePassing.updateElapsedTime()
        self.view.isUserInteractionEnabled = false
        Game.current.setColor(pencilToColor(pencil: selectedPencil!), forDigit: exercise.firstDigit)
        progressBar.setProgressWithAnimation(CGFloat(globalStagePassing.nextProgress))
        let result = globalStagePassing.rightAnswerResult
        globalStagePassing.rightAnswer()
        var vc: UIViewController!
        switch result {
        case .endOfGlobalStage:
            ServerTaskManager.pushBack(.introductionFinished())
            let stageMapVC = StageMapVC(nibName: "StageMapVC", bundle: nil)
            vc = stageMapVC
            break
        case .endOfStage:
            let inBetweenVC = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
            inBetweenVC.mode = .beforeIntroductionExam
            inBetweenVC.globalStagePassing = self.globalStagePassing
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
    }
}
