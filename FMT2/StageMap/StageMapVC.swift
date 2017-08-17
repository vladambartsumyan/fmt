import UIKit
import RealmSwift
import SVGKit
import StoreKit

class StageMapVC: FadeInOutVC {

    let lockedFrom = 5
    
    var fullVersion: SKProduct? = nil
    var productsRequests: SKProductsRequest!
    
    @IBOutlet weak var menuButton: TopButton!
    @IBOutlet weak var background: UIImageView!

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

    @IBOutlet weak var map: UIView!

    @IBOutlet weak var statistic: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!

    var mapButtons: [MapButton] = []

    var curGlobalStagePassing: GlobalStagePassing? = nil

    var globalStages: Results<GlobalStagePassing>!
    var token: NotificationToken!

    @IBOutlet weak var trainingButton: TextButton!
    var proportion: CGFloat = UIScreen.main.bounds.width / 414

    @IBOutlet weak var gradientBottomBorder: UIView!
    @IBOutlet weak var gradientUpBorder: UIView!

    var lines: [CAShapeLayer] = []
    
    @IBOutlet weak var heightOfBottomPanel: NSLayoutConstraint!
    @IBOutlet weak var proportionOfBottomPanel: NSLayoutConstraint!

    let isFullVersion = UserDefaults.standard.bool(forKey: UserDefaultsKey.isFullVersion.rawValue)
    
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

        background.image = SVGKImage(named: "background").uiImage
        menuButton.setIcon(withName: "MenuIcon")
        
        curGlobalStagePassing = Game.current.currentGlobalStagePassing
        globalStages = (try! Realm()).objects(GlobalStagePassing.self).sorted(byKeyPath: "_type")
        configureTrainingButton()
        self.updateButtons()
        configureStatistic()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GAManager.track(screen: .stageMap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
        drawLine()
        addGradientToBottomBorder()
        addGradientToUpBorder()
        scrollToCurrent()
    }

    func scrollToCurrent() {
        let curButton: MapButton = mapButtons.filter{$0.mode == MapButton.MapButtonMode.current}.first ?? button12!
        let yOfCurButton = curButton.center.y
        var contentOffset = yOfCurButton - scrollView.frame.height / 2
        let minContentOffset: CGFloat = 0.0
        let maxContentOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        if contentOffset < minContentOffset {
            contentOffset = minContentOffset
        }
        if contentOffset > maxContentOffset {
            contentOffset = maxContentOffset
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: contentOffset), animated: false)
    }
    
    func configureStatistic() {
        let passedCount = mapButtons.filter {
            $0.mode == .passed
        }.count
        let totalCount = mapButtons.count
        let text = NSLocalizedString("StageMap.statistic", comment: "") + ": \(passedCount)/\(totalCount)"

        self.statistic.attributedText = NSAttributedString(
                string: text,
                attributes: [
                        NSFontAttributeName: UIFont(name: "Lato-Black", size: 22 * proportion)!,
                        NSStrokeWidthAttributeName: -2.0,
                        NSStrokeColorAttributeName: UIColor.black,
                        NSForegroundColorAttributeName: UIColor.white
                ]
        )
    }

    func updateButtons() {
        for ind in 0..<globalStages.count {
            configureButton(mapButtons[ind], withGlobalStagePassing: globalStages[ind])
        }
        (isFullVersion ? mapButtons : Array(mapButtons.dropLast(mapButtons.count - lockedFrom))).filter {
            $0.mode == .locked
        }.forEach {
            $0.isEnabled = false
        }
    }

    func configureTrainingButton() {
        let needsTrainingButton = curGlobalStagePassing == nil || curGlobalStagePassing!._type > StageType.multiplicationBy0.rawValue
        if needsTrainingButton {
            heightOfBottomPanel.priority = 900
            proportionOfBottomPanel.priority = 1000
        } else {
            heightOfBottomPanel.priority = 1000
            proportionOfBottomPanel.priority = 900
        }
        trainingButton.setTitle(titleText: NSLocalizedString("StageMap.trainingButton.title", comment: ""))
    }

    func addGradientToUpBorder() {
        let gradient = CAGradientLayer()

        gradient.frame = gradientUpBorder.bounds
        gradient.colors = [UIColor(red255: 237, green: 244, blue: 254).cgColor, UIColor(red255: 239, green: 246, blue: 254).withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)

        gradientUpBorder.layer.insertSublayer(gradient, at: 0)
    }

    func addGradientToBottomBorder() {
        let gradient = CAGradientLayer()

        gradient.frame = gradientBottomBorder.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)

        gradientBottomBorder.layer.insertSublayer(gradient, at: 0)
    }

    func configureButton(_ button: MapButton, withGlobalStagePassing stage: GlobalStagePassing) {
        guard isFullVersion || stage._type < StageType.multiplicationBy3.rawValue else {
            button.configureWithIcon(mode: .locked, icon: .lock)
            return
        }
                
        let mode = stageToButtonMode(stage: stage)
        switch StageType(rawValue: stage._type)! {
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
        default:
            fatalError("Training stage is unexpected")
        }
    }

    func stageToButtonMode(stage: GlobalStagePassing) -> MapButton.MapButtonMode {
        if let curGlobalStagePassing = curGlobalStagePassing {
            if stage == curGlobalStagePassing {
                return .current
            }
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
        let type = globalStagePassing.type
        switch type {
        case .introduction:
            let vc = IntroductionDigitVC(nibName: "IntroductionDigitVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            simpleFadeOut {
                AppDelegate.current.setRootVC(vc)
            }
            break
        case .multiplicationBy0:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionZeroVC(nibName: "IntroductionZeroVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            }
            break
        case .multiplicationBy1:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionOneVC(nibName: "IntroductionOneVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            }
            GAManager.track(screen: .multBy1)
            break
        case .multiplicationBy10:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionTenVC(nibName: "IntroductionTenVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            } else {
                let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                vc.skipSecondDigit = true
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            }
            break
        case .permutation:
            let needTutorial = globalStagePassing.index == 0 && globalStagePassing.currentStagePassing!.index == 0
            if needTutorial {
                let vc = IntroductionPermutationVC(nibName: "IntroductionPermutationVC", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            } else {
                let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
                vc.globalStagePassing = globalStagePassing
                simpleFadeOut {
                    AppDelegate.current.setRootVC(vc)
                }
            }
            break
        default:
            let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            simpleFadeOut {
                AppDelegate.current.setRootVC(vc)
            }
            break
        }
        GAManager.track(screen: screenForType(type))
    }
    
    func screenForType(_ type: StageType) -> TrackingScreen {
        switch type {
        case .introduction:
            return .introduction
        case .multiplicationBy0:
            return .multBy0
        case .multiplicationBy1:
            return .multBy1
        case .multiplicationBy2:
            return .multBy2
        case .multiplicationBy3:
            return .multBy3
        case .multiplicationBy4:
            return .multBy4
        case .multiplicationBy5:
            return .multBy5
        case .multiplicationBy6:
            return .multBy6
        case .multiplicationBy7:
            return .multBy7
        case .multiplicationBy8:
            return .multBy8
        case .multiplicationBy9:
            return .multBy9
        case .multiplicationBy10:
            return .multBy10
        case .permutation:
            return .permutation
        case .training:
            return .training
        }
    }

    @IBAction func buttonPressed(_ sender: MapButton) {
        let index = mapButtons.index(of: sender)!
        
        if !isFullVersion && index >= lockedFrom {
            fetchProduct()
            return
        }
        
        self.view.isUserInteractionEnabled = false
        let stage = globalStages[index]
        let duration = UserDefaults.standard.bool(forKey: UserDefaultsKey.voiceOn.rawValue) ? SoundHelper.shared.duration(stage.type.string) : 0
        if curGlobalStagePassing != nil && stage == curGlobalStagePassing {
            if curGlobalStagePassing!.index == -1 {
                curGlobalStagePassing!.setZeroIndex()
                GAManager.track(action: .levelStart(level: curGlobalStagePassing!.type), with: .game)
            } else {
                GAManager.track(action: .levelContinue(level: curGlobalStagePassing!.type), with: .game)
            }
            self.perform(#selector(self.loadGlobalStage), with: curGlobalStagePassing!, afterDelay: duration)
        } else {
            let globalStagePassing = globalStages[index].globalStage.createGlobalStagePassing()
            globalStagePassing.saveStages()
            globalStagePassing.inGame = false
            globalStagePassing.setZeroIndex()
            GAManager.track(action: .levelUserRestart(level: globalStagePassing.type), with: .game)
            self.perform(#selector(self.loadGlobalStage), with: globalStagePassing, afterDelay: duration)
        }
        SoundHelper.shared.playVoice(name: stage.type.string)
    }

    func drawLine() {
        lines.forEach {
            $0.removeFromSuperlayer()
        }
        lines.removeAll()

        let r = button0.frame.width / 2
        var points: [CGPoint] = []

        points.append(button0.convert(pointOnCircle(withRadius: r, angle: 90, shift: 8), to: map))
        points.append(button1.convert(pointOnCircle(withRadius: r, angle: 190, shift: 0), to: map))
        points.append(button1.convert(pointOnCircle(withRadius: r, angle: 10, shift: 10), to: map))
        points.append(button2.convert(pointOnCircle(withRadius: r, angle: 190, shift: 0), to: map))
        points.append(button2.convert(pointOnCircle(withRadius: r, angle: 105, shift: 8), to: map))
        points.append(button3.convert(pointOnCircle(withRadius: r, angle: -10, shift: 0), to: map))
        points.append(button3.convert(pointOnCircle(withRadius: r, angle: 165, shift: 10), to: map))
        points.append(button4.convert(pointOnCircle(withRadius: r, angle: -10, shift: 0), to: map))
        points.append(button4.convert(pointOnCircle(withRadius: r, angle: 65, shift: 10), to: map))
        points.append(button5.convert(pointOnCircle(withRadius: r, angle: -165, shift: 0), to: map))
        points.append(button5.convert(pointOnCircle(withRadius: r, angle: 7, shift: 10), to: map))
        points.append(button6.convert(pointOnCircle(withRadius: r, angle: -120, shift: 0), to: map))
        points.append(button6.convert(pointOnCircle(withRadius: r, angle: 145, shift: 10), to: map))
        points.append(button7.convert(pointOnCircle(withRadius: r, angle: -18, shift: 0), to: map))
        points.append(button7.convert(pointOnCircle(withRadius: r, angle: 178, shift: 10), to: map))
        points.append(button8.convert(pointOnCircle(withRadius: r, angle: -30, shift: 0), to: map))
        points.append(button8.convert(pointOnCircle(withRadius: r, angle: 65, shift: 10), to: map))
        points.append(button9.convert(pointOnCircle(withRadius: r, angle: -165, shift: 0), to: map))
        points.append(button9.convert(pointOnCircle(withRadius: r, angle: 7, shift: 10), to: map))
        points.append(button10.convert(pointOnCircle(withRadius: r, angle: -120, shift: 0), to: map))
        points.append(button10.convert(pointOnCircle(withRadius: r, angle: 145, shift: 10), to: map))
        points.append(button11.convert(pointOnCircle(withRadius: r, angle: -18, shift: 0), to: map))
        points.append(button11.convert(pointOnCircle(withRadius: r, angle: 176, shift: 10), to: map))
        points.append(button12.convert(pointOnCircle(withRadius: r, angle: -70, shift: 0), to: map))

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
            addDashedLineOnMap(fromPoint: points[ind * 2], toPoint: points[ind * 2 + 1], reached: reached, withControlPoint: controlPoints[ind])
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
        lines.append(layer)
    }

    func pointOnCircle(withRadius radius: CGFloat, angle: CGFloat, shift: CGFloat) -> CGPoint {
        let shift = shift * proportion
        let radians = angle * CGFloat.pi / 180
        let center = CGPoint(x: radius, y: radius)
        return CGPoint(x: center.x + (radius + shift) * cos(radians), y: center.y + (radius + shift) * sin(radians))
    }

    @IBAction func menuButtonTouched(_ sender: TopButton) {
        self.view.isUserInteractionEnabled = false
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        AppDelegate.current.setRootVCWithAnimation(vc, animation: .transitionFlipFromLeft)
    }

    @IBAction func trainingButtonTouched(_ sender: TextButton) {
        let trainingGlobalStagePassing = GlobalStage.createTrainingGlobalStage().createGlobalStagePassing()
        trainingGlobalStagePassing.saveStages()

        let specialLevels = [StageType.multiplicationBy0, .multiplicationBy1, .multiplicationBy10]
        let firstExerciseIsSpecial = specialLevels.contains(trainingGlobalStagePassing.type)

        let vc: IsGameVC!
        if !firstExerciseIsSpecial {
            vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
        } else {
            vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
            (vc as! ExerciseNumbers).skipSecondDigit = true
        }
        vc.globalStagePassing = trainingGlobalStagePassing
        simpleFadeOut {
            AppDelegate.current.setRootVC(vc as! UIViewController)
        }
        GAManager.track(screen: .training)
        GAManager.track(action: .levelStart(level: .training), with: .game)
    }

    override func getFadeInArray() -> [[UIView]] {
        return [[menuButton, statistic], [scrollView], [trainingButton]]
    }

    override func getFadeOutArray() -> [[UIView]] {
        return [[menuButton, statistic], [scrollView], [trainingButton]]
    }
}
