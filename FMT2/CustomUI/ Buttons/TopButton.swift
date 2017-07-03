import UIKit

class TopButton: LeapingButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("TopButton", owner: self, options: nil)
        self.view.frame = self.frame
        self.view.center = self.center - self.frame.origin
        self.addSubview(self.view)
    }

    func setIcon(withName name: String) {
        self.icon.image = UIImage.init(named: name)
    }
}
