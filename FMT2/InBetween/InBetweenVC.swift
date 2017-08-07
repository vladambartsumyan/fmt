import UIKit
import SVGKit

class InBetweenVC: FadeInOutVC, IsGameVC{

    @IBOutlet weak var bubble: UIImageView!

    @IBOutlet weak var gooseImage: UIImageView!
    @IBOutlet weak var background: UIImageView!

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
        fadeIn {
            let duration = SoundHelper.shared.duration(self.fileName)
            self.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.dismissSelf), userInfo: nil, repeats: false)
            SoundHelper.shared.playVoice(name: self.fileName)
        }
    }
    
    var fileName: String {
        switch self.mode! {
        case .beforeExam, .beforeMultByOneExam, .beforeMultByTenExam, .beforeMultByZeroExam, .beforeIntroductionExam:
            return "beforeexam"
        case .examFailed, .multByOneExamFailed, .permutationExamFailed, .multByTenExamFailed, .multByZeroExamFailed, .introductionExamFailed:
            return "examfailed"
        case .examPassed, .multByOneExamPassed, .multByTenExamPassed, .multByZeroExamPassed, .introductionExamPassed:
            return "exampassed"
        case .permutationExamPassed:
            return "endgame"
        case .trainingPassed:
            return "endgame"
        case .afterZeroTutorial, .afterOneTutorial, .afterTenTutorial, .afterPermutationTutorial:
            return "exercises"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureImage() {
        bubble.image = SVGKImage(named: "bubbleLeftInBetween").uiImage
        background.image = SVGKImage(named: "background").uiImage
        let color = Game.current.getColor(forDigit: 2)
        gooseImage.image = SVGKImage(named: "\(color.rawValue)InBetween").uiImage
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
        case .introductionExamPassed, .multByZeroExamPassed, .multByOneExamPassed, .multByTenExamPassed, .examPassed, .permutationExamPassed, .trainingPassed:
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
    case permutationExamPassed
    case permutationExamFailed
    case trainingPassed
}
