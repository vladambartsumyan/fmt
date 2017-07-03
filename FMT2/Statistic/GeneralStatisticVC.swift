import UIKit

class GeneralStatisticVC: UIViewController, IsGameVC {
    
    let statistic = Statistic()
    
    // Top Bar
    @IBOutlet weak var dismissButton: TopButton!

    // Digit Statistic
    @IBOutlet weak var digitStatisticHeader: UILabel!
    @IBOutlet weak var digitStatisticProgressBar: ProgressBar!
    @IBOutlet weak var digitStatisticMistakeCount: UILabel!
    @IBOutlet weak var digitStatisticMistakeLabel: UILabel!
    
    // Exercise Statistic
    @IBOutlet weak var exerciseStatisticHeader: UILabel!
    @IBOutlet weak var exerciseStatisticProgressBar: ProgressBar!
    @IBOutlet weak var exerciseStatisticElapsedTimeLabel: UILabel!
    @IBOutlet weak var exerciseStatisticElapsedTime: UILabel!
    @IBOutlet weak var exerciseStatisticMistakeLabel: UILabel!
    @IBOutlet weak var exerciseStatisticmistakeCount: UILabel!
    
    // Bonus Statistic
    @IBOutlet weak var bonusStatisticHeader: UILabel!
    @IBOutlet weak var bonusStatisticElapsedTimeLabel: UILabel!
    @IBOutlet weak var bonusStatisticElapsedTime: UILabel!
    @IBOutlet weak var bonusStatisticRightAnswersLabel: UILabel!
    @IBOutlet weak var bonusStatisticRightAnswerCount: UILabel!
    @IBOutlet weak var bonusStatisticMistakeLabel: UILabel!
    @IBOutlet weak var bonusStatisticMistakeCount: UILabel!
    
    @IBOutlet weak var moreButton: TextButton!
    
    // Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopBar()
        configureStatistic()
        configureMoreButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Configures
    
    func configureTopBar() {
        dismissButton.setIcon(withName: "LeftArrowButton")
    }
    
    func configureStatistic() {
        configureIntroductionStatistic()
        configureExerciseStatistic()
        configureBonusStatistic()
        configureFonts()
    }
    
    func configureIntroductionStatistic() {
        // header
        var header = NSLocalizedString("Statistic.introduction.title", comment: "")
//        header += " " + String(statistic.introductionPassedCount) + "/" + String(GameStage.introduction.levelsNumber)
        digitStatisticHeader.attributedText = createHeaderText(fromString: header)
        
        // progress bar
        digitStatisticProgressBar.proportionHeadToFrameHeight *= 33/54
        digitStatisticProgressBar.proportionBodyToHead *= 14/13
        digitStatisticProgressBar.progress = statistic.introductionProgress
        digitStatisticProgressBar.labelNeeded = true
        
        // mistakes
        digitStatisticMistakeLabel.text = NSLocalizedString("Statistic.introduction.mistakes", comment: "")
        digitStatisticMistakeCount.text = String(statistic.introductionMistakeCount)
    }
    
    func configureExerciseStatistic() {
        // header
        var header = NSLocalizedString("Statistic.exercises.title", comment: "")
//        header += " " + String(statistic.exercisePassedCount) + "/" + String(GameStage.exercise.levelsNumber)
        exerciseStatisticHeader.attributedText = createHeaderText(fromString: header)
        
        // progress bar
        exerciseStatisticProgressBar.proportionHeadToFrameHeight *= 33/54
        exerciseStatisticProgressBar.proportionBodyToHead *= 14/13
        exerciseStatisticProgressBar.progress = statistic.exerciseProgress
        exerciseStatisticProgressBar.labelNeeded = true
        
        // elapsed time
        exerciseStatisticElapsedTimeLabel.text = NSLocalizedString("Statistic.exercises.elapsedTime", comment: "")
        exerciseStatisticElapsedTime.text = statistic.exerciseElapsedTime.toTimeStringHMS
        
        // mistakes
        exerciseStatisticMistakeLabel.text = NSLocalizedString("Statistic.exercises.mistakes", comment: "")
        exerciseStatisticmistakeCount.text = String(statistic.exerciseMistakeCount)
    }
    
    func configureBonusStatistic() {
        // header
        let header = NSLocalizedString("Statistic.bonus.title", comment: "")
        bonusStatisticHeader.attributedText = createHeaderText(fromString: header)
        
        // elapsed time
        bonusStatisticElapsedTimeLabel.text = NSLocalizedString("Statistic.bonus.elapsedTime", comment: "")
        bonusStatisticElapsedTime.text = statistic.bonusElapsedTime.toTimeStringHMS
        
        // right answer count
        bonusStatisticRightAnswersLabel.text = NSLocalizedString("Statistic.bonus.rightAnswers", comment: "")
        bonusStatisticRightAnswerCount.text = String(statistic.bonusPassedCount)
        
        // mistakes
        bonusStatisticMistakeLabel.text = NSLocalizedString("Statistic.bonus.mistakes", comment: "")
        bonusStatisticMistakeCount.text = String(statistic.bonusMistakeCount)
    }
    
    func configureMoreButton() {
        moreButton.setTitle(titleText: NSLocalizedString("Statistic.more", comment: ""))
    }
    
    func createHeaderText(fromString header: String) -> NSAttributedString {
        let attrStr = NSMutableAttributedString.init(string: header)
        let attributes: [String : Any] = [
            NSStrokeWidthAttributeName : -4,
            NSStrokeColorAttributeName : UIColor.init(white: 100/255, alpha: 1.0),
            NSFontAttributeName : UIFont.init(name: "Lato-Black", size: 30 * UIScreen.main.bounds.width / 414.0)!,
            NSForegroundColorAttributeName : UIColor.white,
        ]
        attrStr.addAttributes(attributes, range: NSRange.init(location: 0, length: header.characters.count))
        return attrStr
    }
    
    func configureFonts() {
        let font = UIFont.systemFont(ofSize: 19 * UIScreen.main.bounds.width / 414.0)
        [
            digitStatisticMistakeLabel, 
            digitStatisticMistakeCount, 
            exerciseStatisticElapsedTimeLabel, 
            exerciseStatisticElapsedTime, 
            exerciseStatisticMistakeLabel, 
            exerciseStatisticmistakeCount, 
            bonusStatisticElapsedTimeLabel, 
            bonusStatisticElapsedTime, 
            bonusStatisticRightAnswerCount, 
            bonusStatisticRightAnswersLabel, 
            bonusStatisticMistakeLabel, 
            bonusStatisticMistakeCount
        ].forEach{$0.font = font}
    }
    
    // handlers 
    
    @IBAction func dismissButtonPressed(_ sender: TopButton) {
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        (UIApplication.shared.delegate as! AppDelegate).setRootVCWithAnimation(vc, animation: .transitionFlipFromLeft)
    }
    
    @IBAction func moreButtonTouchUpInside(_ sender: TextButton) {
        let vc = MoreStatisticVC(nibName: "MoreStatisticVC", bundle: nil)
        (UIApplication.shared.delegate as! AppDelegate).setRootVC(vc)
    }
    
    var isGameViewController: Bool {
        return false
    }
}
