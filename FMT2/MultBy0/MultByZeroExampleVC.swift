import UIKit
import SVGKit

class MultByZeroExampleVC: FadeInOutVC, IsGameVC {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var firstDigit: UIImageView!
    @IBOutlet weak var secondDigit: UIImageView!
    @IBOutlet weak var result: UIImageView!
    
    @IBOutlet weak var firstDigitEx: UIImageView!
    @IBOutlet weak var secondDigitEx: UIImageView!
    @IBOutlet weak var answerFirstDigit: UIImageView!
    @IBOutlet weak var multiplicationEx: UIImageView!
    @IBOutlet weak var equalityEx: UIImageView!
    
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var newGameButton: TopButton!
    
    var globalStagePassing: GlobalStagePassing!
    
    let digitWidth = 40.0 * UIScreen.main.bounds.width / 414.0
    let signWidth = 30.0 * UIScreen.main.bounds.width / 414.0
    
    @IBOutlet weak var firstDigitWidth: NSLayoutConstraint!
    @IBOutlet weak var equalityWidth: NSLayoutConstraint!
    @IBOutlet weak var secondDigitWidth: NSLayoutConstraint!
    @IBOutlet weak var multiplicationWidth: NSLayoutConstraint!
    @IBOutlet weak var resultWidth: NSLayoutConstraint!
    
    override var needsToTimeAccumulation: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExerciseSize()
        menuButton.setIcon(withName: "MenuIcon")
        newGameButton.setIcon(withName: "NewGameIcon")
        progressBar.progress = CGFloat(globalStagePassing.progress)
        configureImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalStagePassing.addElapsedTime()
        fadeIn {
            let fileName = self.globalStagePassing.type.string + "example"
            let duration = SoundHelper.shared.duration(fileName)
            
            SoundHelper.shared.playVoice(name: fileName)
            self.perform(#selector(self.showHat), with: nil, afterDelay: duration / 2)
            self.perform(#selector(self.nextScreen), with: nil, afterDelay: duration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureImage() {
        background.image = SVGKImage(named: "background").uiImage
        let gooseColor = Game.current.getColor(forDigit: 2)
        self.firstDigit.image = UIImage(named: "2" + gooseColor.rawValue)
        
        let zeroColor = Game.current.getColor(forDigit: 0)
        secondDigit.image = UIImage(named: "\(0)\(zeroColor.rawValue)")
        secondDigit.alpha = 0.0
        
        result.image = SVGKImage.init(named: "0").uiImage
        result.alpha = 0.0
        
        backgroundImage.image = nil
    }
    
    func configureExerciseSize() {
        [firstDigitWidth, secondDigitWidth, resultWidth].forEach{$0?.constant = self.digitWidth}
        [equalityWidth, multiplicationWidth].forEach{$0?.constant = self.signWidth} 
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [
            [firstDigit], 
            [firstDigitEx, secondDigitEx, answerFirstDigit, multiplicationEx, equalityEx]
        ]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [
            [backgroundImage, secondDigit, result], 
            [firstDigitEx, secondDigitEx, answerFirstDigit, multiplicationEx, equalityEx]
        ]
    }
    
    func nextScreen() {
        globalStagePassing.updateElapsedTime()
        let vc = InBetweenVC(nibName: "InBetweenVC", bundle: nil)
        vc.globalStagePassing = self.globalStagePassing
        vc.mode = .afterZeroTutorial
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
    
    func showHat() {
        self.secondDigit.transform = CGAffineTransform.init(translationX: 0, y: -self.secondDigit.frame.height)
        self.result.transform = CGAffineTransform.init(translationX: 0, y: -self.secondDigit.frame.height)
        UIView.animate(withDuration: 0.8) {
            self.secondDigit.transform = .identity
            self.secondDigit.alpha = 1.0
            self.result.transform = .identity
            self.result.alpha = 1.0
        }
        UIView.animate(withDuration: 0.3, delay: 0.5, animations: {
            self.firstDigit.alpha = 0.0
        })
    }
    
    func play(name: String) {
        SoundHelper.shared.playVoice(name: name)
    }
}
