import UIKit
import SVGKit

class IntroductionPermutationVC: FadeInOutVC, IsGameVC {
    
    @IBOutlet weak var background: UIImageView!
    var globalStagePassing: GlobalStagePassing!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var result: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    var needTutorial = true
    
    @IBOutlet weak var skipButton: TextButton!
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopBar()
        configureText()
        configureImages()
        configureSkipButton()
        background.image = SVGKImage(named: "background").uiImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn {
            let tutorialName = StageType.permutation.string + "tutorial"
            SoundHelper.shared.playVoice(name: tutorialName)
            self.perform(#selector(self.nextVC), with: nil, afterDelay: 5)
        }
        globalStagePassing.addElapsedTime()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureTopBar() {
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
    }
    
    func configureImages() {
        backgroundImage.image = SVGKImage(named: "x23background").uiImage
        let gooseColor = Game.current.getColor(forDigit: 2)
        let sparrowColor = Game.current.getColor(forDigit: 3)
        firstDigit.image = SVGKImage(named: "x232" + gooseColor.rawValue).uiImage
        secondDigit.image = SVGKImage(named: "x233" + sparrowColor.rawValue).uiImage
        result.image = SVGKImage(named: "x23result").uiImage
    }
    
    func configureSkipButton() {
        let title = NSLocalizedString("SkipButton.title", comment: "")
        skipButton.setTitle(titleText: title)
    }
    
    func configureText() {
        textLabel.text = NSLocalizedString("Tutorial.permutation.text", comment: "")
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[result, secondDigit, firstDigit, backgroundImage], [textLabel], [skipButton]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return needTutorial ? [[textLabel]] : [[result, secondDigit, firstDigit, backgroundImage],[textLabel], [skipButton]]
    }
    
    @objc func nextVC() {
        guard needTutorial else { return }
        globalStagePassing.updateElapsedTime()
        let vc = PermutationExampleVC(nibName: "PermutationExampleVC", bundle: nil)
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
        vc.mode = .afterPermutationTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
}
