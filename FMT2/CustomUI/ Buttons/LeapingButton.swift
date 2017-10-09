import UIKit

class LeapingButton: UIControl {

    @IBOutlet weak internal var body: UIImageView!

    @IBOutlet internal var  view: UIView!

    @IBOutlet weak internal var icon: UIImageView!

    @IBOutlet weak internal var titleRight: UILabel!

    @IBOutlet weak internal var titleLeft: UILabel!

    @IBOutlet weak internal var titleDown: UILabel!

    @IBOutlet weak internal var titleUp: UILabel!

    private var originalOrigin: CGPoint!

    func touchDown(_ handler: (() -> ())?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            handler?()
        }
    }

    func touchUp() {
        self.sendValueChanged()
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            self.normalize(self.sendTouchUpInside)
        }
    }

    func normalize(_ handler: (() -> ())?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in
            handler?()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.originalOrigin = self.frame.origin
        super.touchesBegan(touches, with: event)
        self.sendTouchDown()
        self.touchDown(nil)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let locationInOriginalSelf: CGPoint = touches.first!.location(in: self.superview!) - self.originalOrigin
        let vector: CGVector = locationInOriginalSelf - self.view.center
        if (CGVector.length(vector: vector) >= 200) {
            self.normalize(self.sendTouchDragOutside)
        } else {
            self.touchDown(self.sendTouchDragInside)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let locationInOriginalSelf: CGPoint = touches.first!.location(in: self.superview!) - self.originalOrigin
        let vector: CGVector = locationInOriginalSelf - self.view.center
        if (CGVector.length(vector: vector) >= 200) {
            self.sendTouchUpOutside()
        } else {
            playSound()
            self.touchUp()
        }
    }

    func playSound() {
        SoundHelper.playDefault()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.normalize {
            self.sendActions(for: .touchCancel)
        }
    }
    
    func sendValueChanged() {
        self.sendActions(for: .valueChanged)
    }

    func sendTouchUpInside() {
        self.sendActions(for: .touchUpInside)
    }

    func sendTouchUpOutside() {
        self.sendActions(for: .touchUpOutside)
    }

    func sendTouchDragInside() {
        self.sendActions(for: .touchDragInside)
    }

    func sendTouchDragOutside() {
        self.sendActions(for: .touchDragOutside)
    }

    func sendTouchCancel() {
        self.sendActions(for: .touchCancel)
    }

    func sendTouchDown() {
        self.sendActions(for: .touchDown)
    }
}
