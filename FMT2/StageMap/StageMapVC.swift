import UIKit
import RealmSwift

class StageMapVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var curGlobalStagePassing: GlobalStagePassing!
    
    var globalStages: Results<GlobalStagePassing>!
    var token: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curGlobalStagePassing = Game.current.currentGlobalStagePassing
        tableView.register(StageCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "StageCell", bundle: nil), forCellReuseIdentifier: "cell")
        globalStages = (try! Realm()).objects(GlobalStagePassing.self).sorted(byKeyPath: "_type")
        token = globalStages.addNotificationBlock { (changes) in
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalStages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StageCell
        cell.label.text = "\(globalStages[indexPath.row]._type)"
        if globalStages[indexPath.row]._type > curGlobalStagePassing._type {
            cell.backgroundColor = .lightGray
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if globalStages[indexPath.row]._type == curGlobalStagePassing._type {
            loadGlobalStage(curGlobalStagePassing)
        } else {
            let globalStagePassing = globalStages[indexPath.row].globalStage.createGlobalStagePassing()
            loadGlobalStage(globalStagePassing)
        }
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
        default:
            let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            AppDelegate.current.setRootVC(vc)
            break
        }
    }
}
