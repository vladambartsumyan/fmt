import UIKit

class IntroductionPermutationVC: FadeInOutVC, IsGameVC {
    
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
    
    func configureText() {
        textLabel.text = NSLocalizedString("Tutorial.permutation.text", comment: "")
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[result, secondDigit, firstDigit, background], [textLabel]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [[textLabel]]
    }
    
    func nextVC() {
        globalStagePassing.updateElapsedTime()
        let vc = PermutationExampleVC(nibName: "PermutationExampleVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
}
