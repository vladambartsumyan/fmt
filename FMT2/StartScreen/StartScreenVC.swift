import UIKit
import SVGKit

class StartScreenVC: FadeInOutVC {
    
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var button: TextButton!
    
    let isNewGame = Game.current.newGame
    
    @IBOutlet weak var background: UIImageView!
    private var frameForImage: CGRect? = nil
    
    override func viewDidLoad() {
        self.needsFadeIn = false
        self.image.image = SVGKImage(named: "start").uiImage
        background.image = SVGKImage(named: "background").uiImage
        super.viewDidLoad()
        configureText()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareAnimation()
        animation()
    }
    
    func prepareAnimation() {
        self.view.layoutSubviews()
        self.frameForImage = image.frame
        self.text.alpha = 0.0
        self.button.alpha = 0.0
        self.background.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func animation() {
        image.center = view.center
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            self.image.frame = self.frameForImage!
        }) { (completed) in
            UIView.animate(withDuration: 0.5, animations: {
                self.text.alpha = 1.0
                self.button.alpha = 1.0
                self.background.alpha = 1.0
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureText() {
        text.attributedText = createAttributedText(
            fromString: NSLocalizedString("FunnyMultiTable", comment: ""), 
            strokeColor: UIColor.init(white: 100/255, alpha: 1), 
            sizeForIPhone7Plus: 43
        )
    }
    
    func createAttributedText(fromString string: String, strokeColor: UIColor, sizeForIPhone7Plus size: CGFloat) -> NSAttributedString {
        let attrStr = NSMutableAttributedString.init(string: string)
        let attributes: [String : Any] = [
            NSStrokeWidthAttributeName : -2,
            NSStrokeColorAttributeName : strokeColor,
            NSFontAttributeName : UIFont.init(name: "Lato-Black", size: size * UIScreen.main.bounds.width / 414.0)!,
            NSForegroundColorAttributeName : UIColor.white,
        ]
        attrStr.addAttributes(attributes, range: NSRange.init(location: 0, length: string.characters.count))
        return attrStr
    }
    
    func configureButton() {
        let titleKey = Game.current.newGame ? "StartScreen.newGame" : "StartScreen.continue"
        let title = NSLocalizedString(titleKey, comment: "")
        button.setTitle(titleText: title)
    }
    
    @IBAction func buttonWasPressed(_ sender: TextButton) {
        if isNewGame {
            newGame()
        } else {
            continueGame()
        }
    }
    
    func continueGame() {
        let vc = StageMapVC(nibName: "StageMapVC", bundle: nil)
        fadeOut {
            AppDelegate.current.setRootVC(vc)
        }
    }
    
    func newGame() {
        Game.current.reset()
        let vc = TutorialVC(nibName: "TutorialVC", bundle: nil)
        AppDelegate.current.setRootVCWithAnimation(vc, animation: .transitionFlipFromRight)
    }
    
    override func getFadeInArray() -> [[UIView]] {
        return [[image], [text], [button]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [[image], [text], [button]]
    }
}
