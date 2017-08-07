import UIKit
import SVGKit
class MenuButton: LeapingButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("MenuButton", owner: self, options: nil)
        self.view.frame = self.frame
        self.view.center = self.center - self.frame.origin
        setTitleSize()
        self.addSubview(self.view)
    }

    func setBodyColor(bodyColor: MenuButtonColor) {
        self.body.image = bodyColor.bodyImage
    }

    func setIcon(withName name: String) {
        self.icon.image = SVGKImage.init(named: name).uiImage
    }

    func setTitle(titleText title: String) {
        self.titleUp.text = title
        self.titleDown.text = title
        self.titleLeft.text = title
        self.titleRight.text = title
    }

    func setTitleSize() {
        self.titleUp.font = UIFont.boldSystemFont(ofSize: 16 * UIScreen.main.bounds.height / 480)
        self.titleDown.font = UIFont.boldSystemFont(ofSize: 16 * UIScreen.main.bounds.height / 480)
        self.titleRight.font = UIFont.boldSystemFont(ofSize: 16 * UIScreen.main.bounds.height / 480)
        self.titleLeft.font = UIFont.boldSystemFont(ofSize: 16 * UIScreen.main.bounds.height / 480)
        // where 480 is number of pixels in iPhone 4 height and 16 is size of font for iPhone 4
    }
}
