import UIKit
import RealmSwift

class StageMapVC: UIViewController {
    
    @IBOutlet weak var button0: MapButton!
    @IBOutlet weak var button1: MapButton!
    @IBOutlet weak var button2: MapButton!
    @IBOutlet weak var button3: MapButton!
    @IBOutlet weak var button4: MapButton!
    @IBOutlet weak var button5: MapButton!
    @IBOutlet weak var button6: MapButton!
    @IBOutlet weak var button7: MapButton!
    @IBOutlet weak var button8: MapButton!
    @IBOutlet weak var button9: MapButton!
    @IBOutlet weak var button10: MapButton!
    @IBOutlet weak var button11: MapButton!
    @IBOutlet weak var button12: MapButton!

    var mapButtons: [MapButton] = []
    
    var curGlobalStagePassing: GlobalStagePassing!
    
    var globalStages: Results<GlobalStagePassing>!
    var token: NotificationToken!
    
    var proportion: CGFloat = UIScreen.main.bounds.width / 414
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapButtons.append(button0)
        self.mapButtons.append(button1)
        self.mapButtons.append(button2)
        self.mapButtons.append(button3)
        self.mapButtons.append(button4)
        self.mapButtons.append(button5)
        self.mapButtons.append(button6)
        self.mapButtons.append(button7)
        self.mapButtons.append(button8)
        self.mapButtons.append(button9)
        self.mapButtons.append(button10)
        self.mapButtons.append(button11)
        self.mapButtons.append(button12)
        
        curGlobalStagePassing = Game.current.currentGlobalStagePassing
        globalStages = (try! Realm()).objects(GlobalStagePassing.self).sorted(byKeyPath: "_type")
        token = globalStages.addNotificationBlock { (changes) in
            self.updateButtons()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutAllViews(inView: view)
        drawLine()
    }
    
    func layoutAllViews(inView view: UIView) {
        for subview in view.subviews {
            layoutAllViews(inView: subview)
        }
        view.layoutSubviews()
    }
    
    func updateButtons() {
        for ind in 0..<globalStages.count {
            configureButton(mapButtons[ind], withGlobalStagePassing: globalStages[ind])
        }
    }
    
    func configureButton(_ button: MapButton, withGlobalStagePassing stage: GlobalStagePassing) {
        let mode = stageToButtonMode(stage: stage)
        switch stage.type {
        case .introduction:
            button.configureWithIcon(mode: mode, icon: .paw)
            break
        case .multiplicationBy0:
            button.configureWithTitle(mode: mode, title: "0")
            break
        case .multiplicationBy1:
            button.configureWithTitle(mode: mode, title: "1")
            break
        case .multiplicationBy10:
            button.configureWithTitle(mode: mode, title: "10")
            break
        case .multiplicationBy2:
            button.configureWithTitle(mode: mode, title: "2")
            break
        case .multiplicationBy3:
            button.configureWithTitle(mode: mode, title: "3")
            break
        case .multiplicationBy4:
            button.configureWithTitle(mode: mode, title: "4")
            break
        case .multiplicationBy5:
            button.configureWithTitle(mode: mode, title: "5")
            break
        case .multiplicationBy6:
            button.configureWithTitle(mode: mode, title: "6")
            break
        case .multiplicationBy7:
            button.configureWithTitle(mode: mode, title: "7")
            break
        case .multiplicationBy8:
            button.configureWithTitle(mode: mode, title: "8")
            break
        case .multiplicationBy9:
            button.configureWithTitle(mode: mode, title: "9")
            break
        case .permutation:
            button.configureWithIcon(mode: mode, icon: .star)
            break
        }
    }
    
    func stageToButtonMode(stage: GlobalStagePassing) -> MapButton.MapButtonMode {
        if stage == curGlobalStagePassing {
            return .current
        }
        if stage.isPassed {
            return .passed
        }
        return .locked
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadGlobalStage(_ globalStagePassing: GlobalStagePassing) {
        let type = StageType(rawValue: globalStagePassing._type)!
        switch type {
        case .introduction:
            let vc = IntroductionDigitVC(nibName: "IntroductionDigitVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            AppDelegate.current.setRootVC(vc)
            break
        case .multiplicationBy0:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionZeroVC(nibName: "IntroductionZeroVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                AppDelegate.current.setRootVC(vc)
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                AppDelegate.current.setRootVC(vc)
            }
            break
        case .multiplicationBy1:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionOneVC(nibName: "IntroductionOneVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                AppDelegate.current.setRootVC(vc)
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                AppDelegate.current.setRootVC(vc)
            }
            break
        case .multiplicationBy10:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionTenVC(nibName: "IntroductionTenVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                AppDelegate.current.setRootVC(vc)
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                AppDelegate.current.setRootVC(vc)
            }
            break
        case .permutation:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionPermutationVC(nibName: "IntroductionPermutationVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                AppDelegate.current.setRootVC(vc)
            } else {
                let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                AppDelegate.current.setRootVC(vc)
            }
            break
        default:
            let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            AppDelegate.current.setRootVC(vc)
            break
        }
    }
    
    @IBAction func buttonPressed(_ sender: MapButton) {
        let index = mapButtons.index(of: sender)!
        let stage = globalStages[index]
        if stage == curGlobalStagePassing {
            loadGlobalStage(curGlobalStagePassing)
        } else {
            let globalStagePassing = globalStages[index].globalStage.createGlobalStagePassing()
            loadGlobalStage(globalStagePassing)
        }
    }
    
    @IBOutlet weak var map: UIView!
    
    func drawLine() {
        let d = button0.frame.width
        var points: [CGPoint] = []
        
        
        points.append(button0.convert(pointOnCircle(withRadius: d/2, angle: 90, shift: 8), to: map))
        points.append(button1.convert(pointOnCircle(withRadius: d/2, angle: 190, shift: 0), to: map))
        points.append(button1.convert(pointOnCircle(withRadius: d/2, angle: 10, shift: 10), to: map))
        points.append(button2.convert(pointOnCircle(withRadius: d/2, angle: 190, shift: 0), to: map))
        points.append(button2.convert(pointOnCircle(withRadius: d/2, angle: 105, shift: 8), to: map))
        points.append(button3.convert(pointOnCircle(withRadius: d/2, angle: -10, shift: 0), to: map))
        points.append(button3.convert(pointOnCircle(withRadius: d/2, angle: 165, shift: 10), to: map))
        points.append(button4.convert(pointOnCircle(withRadius: d/2, angle: -10, shift: 0), to: map))
        points.append(button4.convert(pointOnCircle(withRadius: d/2, angle: 65, shift: 10), to: map))
        points.append(button5.convert(pointOnCircle(withRadius: d/2, angle: -165, shift: 0), to: map))
        points.append(button5.convert(pointOnCircle(withRadius: d/2, angle: 7, shift: 10), to: map))
        points.append(button6.convert(pointOnCircle(withRadius: d/2, angle: -120, shift: 0), to: map))
        points.append(button6.convert(pointOnCircle(withRadius: d/2, angle: 145, shift: 10), to: map))
        points.append(button7.convert(pointOnCircle(withRadius: d/2, angle: -18, shift: 0), to: map))
        points.append(button7.convert(pointOnCircle(withRadius: d/2, angle: 178, shift: 10), to: map))
        points.append(button8.convert(pointOnCircle(withRadius: d/2, angle: -30, shift: 0), to: map))
        points.append(button8.convert(pointOnCircle(withRadius: d/2, angle: 65, shift: 10), to: map))
        points.append(button9.convert(pointOnCircle(withRadius: d/2, angle: -165, shift: 0), to: map))
        points.append(button9.convert(pointOnCircle(withRadius: d/2, angle: 7, shift: 10), to: map))
        points.append(button10.convert(pointOnCircle(withRadius: d/2, angle: -120, shift: 0), to: map))
        points.append(button10.convert(pointOnCircle(withRadius: d/2, angle: 145, shift: 10), to: map))
        points.append(button11.convert(pointOnCircle(withRadius: d/2, angle: -18, shift: 0), to: map))
        points.append(button11.convert(pointOnCircle(withRadius: d/2, angle: 176, shift: 10), to: map))
        points.append(button12.convert(pointOnCircle(withRadius: d/2, angle: -70, shift: 0), to: map))
        
        var controlPoints: [CGPoint] = []
        controlPoints.append(CGPoint(x: points[0].x, y: (points[1].y + points[0].y) / 2.0))
        controlPoints.append(CGPoint(x: (points[2].x + points[3].x) / 2, y: (points[2].y + points[3].y) / 2.0 - 5))
        controlPoints.append(CGPoint(x: (points[4].x + points[5].x) / 2, y: (points[4].y + points[5].y) / 2.0 + 5))
        controlPoints.append(CGPoint(x: (points[6].x + points[7].x) / 2, y: (points[6].y + points[7].y) / 2.0 - 5))
        controlPoints.append(CGPoint(x: (points[8].x + points[9].x) / 2, y: (points[8].y + points[9].y) / 2.0 + 5))
        controlPoints.append(CGPoint(x: (points[10].x + points[11].x) / 2, y: (points[10].y + points[11].y) / 2.0 - 5))
        controlPoints.append(CGPoint(x: (points[12].x + points[13].x) / 2, y: (points[12].y + points[13].y) / 2.0))
        controlPoints.append(CGPoint(x: (points[14].x + points[15].x) / 2, y: (points[14].y + points[15].y) / 2.0 - 5))
        controlPoints.append(CGPoint(x: (points[16].x + points[17].x) / 2, y: (points[16].y + points[17].y) / 2.0 + 5))
        controlPoints.append(CGPoint(x: (points[18].x + points[19].x) / 2, y: (points[18].y + points[19].y) / 2.0 - 5))
        controlPoints.append(CGPoint(x: (points[20].x + points[21].x) / 2, y: (points[20].y + points[21].y) / 2.0))
        controlPoints.append(CGPoint(x: points[23].x, y: (points[22].y + points[23].y) / 2.0))
        
        for ind in 0..<controlPoints.count {
            let reached = mapButtons[ind].mode == .passed
            addDashedLineOnMap(fromPoint: points[ind * 2], toPoint: points[ind * 2 + 1], reached: reached,  withControlPoint: controlPoints[ind])
        }
        
    }
    
    func addDashedLineOnMap(fromPoint a: CGPoint, toPoint b: CGPoint, reached: Bool, withControlPoint c1: CGPoint, andControlPoint c2: CGPoint? = nil) {
        let color = reached ? UIColor.init(red255: 164, green: 237, blue: 255).cgColor : UIColor.init(red255: 225, green: 225, blue: 225).cgColor
        
        let path = UIBezierPath()
        path.move(to: a)
        c2 != nil ?
            path.addCurve(to: b, controlPoint1: c1, controlPoint2: c2!) :
            path.addQuadCurve(to: b, controlPoint: c1)
        
        let layer = CAShapeLayer()
        layer.lineWidth = 7 * proportion
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        layer.lineJoin = kCALineJoinRound
        layer.lineCap = kCALineJoinRound
        layer.lineDashPattern = [0.0, NSNumber(value: Double(16 * proportion))]
        layer.path = path.cgPath
        self.map.layer.sublayers != nil ?
            self.map.layer.sublayers!.insert(layer, at: 0) :
            self.map.layer.addSublayer(layer)
    }
    
    func pointOnCircle(withRadius radius: CGFloat, angle: CGFloat, shift: CGFloat) -> CGPoint {
        let shift = shift * proportion
        let radians = angle * CGFloat.pi / 180
        let center = CGPoint(x: radius, y: radius)
        return CGPoint(x: center.x + (radius + shift) * cos(radians), y: center.y + (radius + shift) * sin(radians))
    }
}
