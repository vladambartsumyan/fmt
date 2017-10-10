import UIKit
import SVGKit

class IntroductionTenVC: FadeInOutVC, IsGameVC {
    
    var globalStagePassing: GlobalStagePassing!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var result: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    @IBOutlet weak var skipButton: TextButton!
    
    var needTutorial = true
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopBar()
        configureText()
        configureImage()
        configureSkipButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            let tutorialName = StageType.multiplicationBy10.string + "tutorial"
            let tutorialDuration = SoundHelper.shared.duration(tutorialName)
            self.play(name: tutorialName)
            self.perform(#selector(self.nextVC), with: nil, afterDelay: tutorialDuration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        globalStagePassing.updateElapsedTime()
    }
    
    func configureImage() {
        background.image = SVGKImage(named: "background").uiImage
        let gooseColor = Game.current.getColor(forDigit: 2)
        self.firstDigit.image = SVGKImage.init(named: "x2102" + gooseColor.rawValue).uiImage
    }
    
    func configureTopBar() {
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
    }
    
    func configureText() {
        textLabel.text = NSLocalizedString("Tutorial.ten.text", comment: "")
    }

    func configureSkipButton() {
        let title = NSLocalizedString("SkipButton.title", comment: "")
        skipButton.setTitle(titleText: title)
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[result, secondDigit, firstDigit, backgroundImage], [textLabel], [skipButton]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return needTutorial ? [[textLabel]] : [[result, secondDigit, firstDigit, backgroundImage], [textLabel], [skipButton]]
    }
    
    func play(name: String) {
        SoundHelper.shared.playVoice(name: name)
    }
    
    @objc func nextVC() {
        guard needTutorial else { return }
        globalStagePassing.updateElapsedTime()
        let vc = MultByTenExampleVC(nibName: "MultByTenExampleVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
    
    @IBAction func skipButtonAction(_ sender: TextButton) {
        skipTutorial()
    }
    
    func skipTutorial() {
        needTutorial = false
        SoundHelper.shared.stopVoice()
        globalStagePassing.updateElapsedTime()
        let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        vc.mode = .afterTenTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
}
