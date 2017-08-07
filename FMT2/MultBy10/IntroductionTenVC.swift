import UIKit
import SVGKit

class IntroductionTenVC: FadeInOutVC, IsGameVC {
    
    var globalStagePassing: GlobalStagePassing!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var result: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var newGameButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopBar()
        configureText()
        configureImage()
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

    override func getFadeInArray() -> [[UIView]] {
        return [[result, secondDigit, firstDigit, background], [textLabel]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [[textLabel]]
    }
    
    func play(name: String) {
        SoundHelper.shared.playVoice(name: name)
    }
    
    func nextVC() {
        globalStagePassing.updateElapsedTime()
        let vc = MultByTenExampleVC(nibName: "MultByTenExampleVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
}
