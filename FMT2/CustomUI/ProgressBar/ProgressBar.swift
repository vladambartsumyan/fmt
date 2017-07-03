import UIKit

class ProgressBar: UIControl {

    @IBOutlet var view: UIView!

    @IBOutlet weak var body: UIView!

    var filling: UIView!

    var label: UILabel? = nil
    
    var labelNeeded = false
    
    var shadowColor: UIColor? {
        get {
            return body.backgroundColor
        }
        set {
            body.backgroundColor = newValue
        }
    }

    private var borderWidth: CGFloat = 2.0

    var bodyColor: UIColor = UIColor.init(red255: 207, green: 193, blue: 162)

    var proportionBodyToHead: CGFloat = 0.4
    var proportionHeadToFrameHeight: CGFloat = 1.0 / 1.3
    var proportionFillingToBody: CGFloat = 1.3

    var progress: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("ProgressBar", owner: self, options: nil)
        self.view.frame = self.frame
        self.view.center = self.center - self.view.frame.origin
        self.addSubview(self.view)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        configureBody(rect)
        configureFilling(rect, shift: CGVector(dx: 0, dy: (rect.height * proportionHeadToFrameHeight * proportionBodyToHead * proportionFillingToBody) * 0.35))
        configureLabel()
    }

    func configureBody(_ rect: CGRect) {

        let path = makePathForRect(rect)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.body.layer.mask = mask

        let withoutShadow = CAShapeLayer()
        withoutShadow.path = makePathForRect(rect, shift: CGVector(dx: 0, dy: rect.height * proportionHeadToFrameHeight * proportionBodyToHead * 0.15)).cgPath
        withoutShadow.fillColor = bodyColor.cgColor
        self.body.layer.addSublayer(withoutShadow)
    }

    func configureFilling(_ rect: CGRect, shift: CGVector = CGVector(dx: 0, dy: 0)) {
        self.filling = progress >= 1 ? makeFullFillingView(rect, shift: shift) : makeNotFullFillingView(rect, shift: shift)
        self.view.addSubview(filling)
    }

    func makeNotFullFillingView(_ rect: CGRect, shift: CGVector = CGVector(dx: 0, dy: 0)) -> UIView {
        
        let leftRadius = proportionHeadToFrameHeight * proportionBodyToHead * rect.height / 2
        let leftFillingRadius = leftRadius * proportionFillingToBody
        let rightRadius = rect.height * proportionHeadToFrameHeight / 2
        let rightFillingRadius = rightRadius * proportionFillingToBody
        
        let rightCenter = CGPoint(x: rect.width - rightFillingRadius, y: rect.height / 2)
        let leftCenter = CGPoint(x: leftFillingRadius, y: rect.height / 2)
        
        var fillingFrame: CGRect;

        if (progress > 0) {
            fillingFrame = CGRect.init(
                x: 0,
                y: (rect.height / 2 - leftFillingRadius),
                width: 2 * leftFillingRadius + progress * (rightCenter.x - rightRadius - leftCenter.x),
                height: leftFillingRadius * 2
            )
        } else {
            fillingFrame = CGRect.zero
        }

        let filling = UIView.init(frame: fillingFrame)
        filling.layer.cornerRadius = filling.frame.height / 2
        filling.layer.borderWidth = borderWidth
        filling.layer.borderColor = UIColor.init(red255: 115, green: 120, blue: 127).cgColor
        filling.backgroundColor = UIColor.init(red255: 121, green: 141, blue: 242)


        let withoutShadow = CALayer()
        var withoutShadowFrame = filling.frame
        withoutShadowFrame.origin = CGPoint.zero + shift
        withoutShadow.frame = withoutShadowFrame
        withoutShadow.backgroundColor = UIColor.init(red255: 109, green: 127, blue: 217).cgColor
        withoutShadow.cornerRadius = filling.frame.height / 2
        filling.layer.masksToBounds = true
        filling.layer.addSublayer(withoutShadow)

        return filling
    }

    func makeFullFillingView(_ rect: CGRect, shift: CGVector = CGVector(dx: 0, dy: 0)) -> UIView {
        let filling = UIView.init()
        filling.frame = self.view.frame
        filling.backgroundColor = UIColor.init(red255: 121, green: 141, blue: 242)

        let path = makePathForRect(rect, shift: CGVector(dx: 0, dy: 0), forFilling: true)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        filling.layer.mask = mask


        let withoutShadow = CAShapeLayer()
        withoutShadow.path = makePathForRect(rect, shift: shift, forFilling: true).cgPath
        withoutShadow.fillColor = UIColor.init(red255: 109, green: 127, blue: 217).cgColor
        filling.layer.masksToBounds = true
        filling.layer.addSublayer(withoutShadow)

        let frameLayer = CAShapeLayer()
        frameLayer.path = path.cgPath
        frameLayer.lineWidth = 2 * borderWidth
        frameLayer.strokeColor = UIColor.init(red255: 115, green: 120, blue: 127).cgColor
        frameLayer.fillColor = nil
        filling.layer.addSublayer(frameLayer)

        return filling
    }

    func makePathForRect(_ rect: CGRect, shift: CGVector = CGVector(dx: 0, dy: 0), forFilling: Bool = false) -> UIBezierPath {
        
        let path = UIBezierPath.init()

        let leftRadius = proportionHeadToFrameHeight * proportionBodyToHead * rect.height / 2
        let leftFillingRadius = leftRadius * proportionFillingToBody
        let rightRadius = rect.height * proportionHeadToFrameHeight / 2
        let rightFillingRadius = rightRadius * proportionFillingToBody
        
        let leftR = forFilling ? leftFillingRadius : leftRadius
        let rightR = forFilling ? rightFillingRadius : rightRadius

        let startAngle = asin(leftRadius/rightRadius) - CGFloat.pi
        let endAngle = asin(-leftRadius/rightRadius) + CGFloat.pi
        
        let rightCenter = CGPoint(x: rect.width - rightFillingRadius, y: rect.height / 2) + shift
        let leftCenter = CGPoint(x: leftFillingRadius, y: rect.height / 2) + shift

        // right circle
        path.addArc(withCenter: rightCenter, radius: rightR, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        let nextPoint = leftCenter + CGPoint(x: 0, y: leftR)
        path.addLine(to: nextPoint)

        //left circle
        path.addArc(withCenter: leftCenter, radius: leftR, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi / 2, clockwise: true)

        let startOfRightArc = CGPoint(x: rightCenter.x + rightR * cos(startAngle), y: rightCenter.y + rightR * sin(startAngle))
        path.addLine(to: startOfRightArc)

        path.close()

        return path
    }

    func setProgressWithAnimation(_ progress: CGFloat) {
        self.progress = progress
        let shift = CGVector(dx: 0, dy: (self.view.frame.height * proportionHeadToFrameHeight * proportionBodyToHead * proportionFillingToBody) * 0.35)
        let newFilling = progress >= 1 ?
            makeFullFillingView(self.view.frame, shift: shift) :
            makeNotFullFillingView(self.view.frame, shift: shift)
        newFilling.alpha = 0.0
        self.view.addSubview(newFilling)
        UIView.animate(withDuration: 1, animations: {
            newFilling.alpha = 1
        }) { (completed) in
            self.filling.removeFromSuperview()
            self.filling = newFilling
        }
    }

    func configureLabel() {
        guard labelNeeded else {
            return
        }
        
        if label == nil {
            label = UILabel.init()
        }
        
        let rect = self.frame
        let leftRadius = proportionHeadToFrameHeight * proportionBodyToHead * rect.height / 2
        let leftFillingRadius = leftRadius * proportionFillingToBody
        let rightRadius = rect.height * proportionHeadToFrameHeight / 2
        let rightFillingRadius = rightRadius * proportionFillingToBody
        
        let rightCenter = CGPoint(x: rect.width - rightFillingRadius, y: rect.height / 2)
        let leftCenter = CGPoint(x: leftFillingRadius, y: rect.height / 2)
        
        label?.text = String(Int(round(progress * 100))) + "%"
        label?.textColor = UIColor.white
//        label?.shadowColor = UIColor.black
//        label?.shadowOffset = CGSize.init(width: 1, height: 1)
        label?.font = UIFont.init(name: "Lato-Black", size: leftRadius * 1.9)
        label?.sizeToFit()
        var labelFrame = CGRect.init()
        // x
        let progressWidth = progress * (rightCenter.x - rightRadius - leftCenter.x)
        if (progressWidth < label!.frame.width) {
            labelFrame.origin.x = leftCenter.x
        } else {
            labelFrame.origin.x = leftCenter.x + progressWidth - label!.frame.width
        }
        // y
        labelFrame.origin.y = leftCenter.y - label!.frame.height / 2
        // size
        labelFrame.size = label!.frame.size
        
        label?.frame = labelFrame
        if progress == 1.0 {
            label?.center = rightCenter
        }
        if label?.superview == nil {
            self.addSubview(label!)
        }
    }
    
}
