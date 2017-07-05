import UIKit

class InBetweenVC: FadeInOutVC, IsGameVC{

    @IBOutlet weak var bubble: UIImageView!

    @IBOutlet weak var gooseImage: UIImageView!

    private var timer: Timer!

    var mode: InBetweenMode!
    
    var globalStagePassing: GlobalStagePassing!

    @IBOutlet private weak var message: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
        configureMessage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissSelf), userInfo: nil, repeats: false)
        self.fadeIn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureImage() {
        let color = Game.current.getColor(forDigit: 2)
        gooseImage.image = UIImage.init(named: "\(color.rawValue)InBetween")
    }
    
    func configureMessage() {
        self.message.text = NSLocalizedString("InBetween.message.\(mode.rawValue)", comment: "")
    }
    
    func dismissSelf() {
        self.fadeOut {
            AppDelegate.current.setRootVC(self.nextVC())
        }
    }
    
    func nextVC() -> UIViewController {
        switch mode! {
        case .beforeIntroductionExam, .introductionExamFailed:
            let vc = IntroductionDigitVC(nibName: "IntroductionDigitVC", bundle: nil)
            vc.globalStagePassing = self.globalStagePassing
            return vc
        case .introductionExamPassed, .multByZeroExamPassed, .multByOneExamPassed, .multByTenExamPassed, .examPassed:
            let vc = StageMapVC(nibName: "StageMapVC", bundle: nil)
            return vc
        case .afterZeroTutorial, .afterOneTutorial, .afterTenTutorial: 
            let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            vc.skipSecondDigit = true
            return vc
        case .beforeMultByZeroExam, .beforeMultByOneExam, .beforeMultByTenExam:
            let vc = ExerciseNumbers(nibName: "ExerciseNumbers", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            vc.skipSecondDigit = true
            return vc
        case .multByZeroExamFailed:
            let vc = IntroductionZeroVC(nibName: "IntroductionZeroVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            return vc
        case .multByOneExamFailed:
            let vc = IntroductionOneVC(nibName: "IntroductionOneVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            return vc
        case .multByTenExamFailed:
            let vc = IntroductionTenVC(nibName: "IntroductionTenVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            return vc
        case .beforeExam, .examFailed:
            let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            return vc
        case .afterPermutationTutorial:
            let vc = ExercisePreview(nibName: "ExercisePreview", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            return vc
        case .permutationExamFailed:
            let vc = IntroductionPermutationVC(nibName: "IntroductionPermutationVC", bundle: nil)
            vc.globalStagePassing = globalStagePassing
            return vc
        }
    }

    override func getFadeInArray() -> [[UIView]] {
        return [[message, bubble], [gooseImage]]
    }
    
    override func getFadeOutArray() -> [[UIView]] {
        return [[message, bubble], [gooseImage]]
    }
}

enum InBetweenMode: String {
    case beforeIntroductionExam
    case introductionExamFailed
    case introductionExamPassed
    case afterZeroTutorial
    case beforeMultByZeroExam
    case multByZeroExamPassed
    case multByZeroExamFailed
    case afterOneTutorial
    case beforeMultByOneExam
    case multByOneExamPassed
    case multByOneExamFailed
    case afterTenTutorial
    case beforeMultByTenExam
    case multByTenExamPassed
    case multByTenExamFailed
    case beforeExam
    case examPassed
    case examFailed
    case afterPermutationTutorial
    case permutationExamFailed
}
