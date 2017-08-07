import UIKit
import SVGKit
class MapButton: LeapingButton {

    private var _mode: MapButtonMode = .locked
    
    var mode: MapButtonMode {
        get {
            return _mode
        }
        set {
            self._mode = newValue
            self.body.image = UIImage(named: newValue.rawValue + "MapButton")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("MapButton", owner: self, options: nil)
        self.view.frame = self.frame
        self.view.center = self.center - self.frame.origin
        setTitleSize()
        self.addSubview(self.view)
    }
    
    func setIcon(withName name: String) {
        setTitle(titleText: "")
        self.icon.image = SVGKImage(named: name).uiImage
    }
    
    func setTitle(titleText title: String) {
        if title != "" {
            self.icon.image = nil
        }
        self.titleUp.text = title
        self.titleDown.text = title
        self.titleLeft.text = title
        self.titleRight.text = title
    }
    
    func setTitleSize() {
        let font = UIFont.init(name: "Lato-Black", size: 37 * UIScreen.main.bounds.width / 414)
        self.titleUp.font = font
        self.titleDown.font = font
        self.titleRight.font = font
        self.titleLeft.font = font
    }
    
    func configureWithIcon(mode: MapButtonMode, icon: MapButtonIcon) {
        self.mode = mode
        setIcon(withName: mode.rawValue + icon.rawValue)
    }
    
    func configureWithTitle(mode: MapButtonMode, title: String) {
        self.mode = mode
        setTitle(titleText: title)
    }
    
    enum MapButtonMode: String {
        case current
        case locked
        case passed
    }
    
    enum MapButtonIcon: String {
        case paw
        case star
    }
}
