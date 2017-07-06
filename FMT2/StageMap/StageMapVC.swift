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
}
