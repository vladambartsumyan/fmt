import UIKit

class MistakesAndRightAnswersCell: UICollectionViewCell, AnimateAndNoAnimate {
    
    @IBOutlet weak var progress1: UIView!
    @IBOutlet weak var progress2: UIView!
    @IBOutlet weak var mistakes: UILabel!
    @IBOutlet weak var rightAnswers: UILabel!
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    var newFrame1: CGRect!
    var newFrame2: CGRect!
    var newMistakesFrame: CGRect!
    var newRightAnswersFrame: CGRect!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.progress1.backgroundColor = UIColor.init(red255: 233, green: 114, blue: 114)
        self.progress2.backgroundColor = UIColor.init(red255: 127, green: 209, blue: 125)
    }
    
    func configureWith(graphStatistic: GraphStatistic) {
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        mistakes.text = String(graphStatistic.mistakes)
        rightAnswers.text = String(graphStatistic.rightAnswers)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        date.text = dateFormatter.string(from: graphStatistic.date)
        
        let oldFrame1 = CGRect.init(x: line.frame.width, y: line.frame.height - 20, width: (self.frame.width - line.frame.width)/2, height: 20)
        self.progress1.frame = oldFrame1
        let oldFrame2 = CGRect.init(x: line.frame.width + oldFrame1.width, y: line.frame.height - 20, width: (self.frame.width - line.frame.width) / 2, height: 20)
        self.progress2.frame = oldFrame2
        
        let oldMistakesFrame = CGRect(
            x: oldFrame1.origin.x, 
            y: oldFrame1.origin.y - 20, 
            width: oldFrame1.width, 
            height: 20
        )
        self.mistakes.frame = oldMistakesFrame
        
        let oldRightAnswersFrame = CGRect(
            x: oldFrame2.origin.x, 
            y: oldFrame2.origin.y - 20, 
            width: oldFrame2.width, 
            height: 20
        )
        self.rightAnswers.frame = oldRightAnswersFrame
        
        self.newFrame1 = CGRect(
            x: line.frame.width, 
            y: 20 + (line.frame.height - 40) * (1 - CGFloat(graphStatistic.percentForMistakes)), 
            width: (self.frame.width - line.frame.width) / 2, 
            height: 20 + (line.frame.height - 40) * CGFloat(graphStatistic.percentForMistakes)
        )
        self.newFrame2 = CGRect(
            x: line.frame.width + self.newFrame1.width, 
            y: 20 + (line.frame.height - 40) * (1 - CGFloat(graphStatistic.percentForRightAnswers)), 
            width: self.newFrame1.width, 
            height: 20 + (line.frame.height - 40) * CGFloat(graphStatistic.percentForRightAnswers)
        )
        
        self.newMistakesFrame = CGRect(
            x: newFrame1.origin.x, 
            y: newFrame1.origin.y - 20, 
            width: newFrame1.width, 
            height: 20
        )
        
        self.newRightAnswersFrame = CGRect(
            x: newFrame2.origin.x, 
            y: newFrame2.origin.y - 20, 
            width: newFrame1.width, 
            height: 20
        )
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5) { 
            self.progress1.frame = self.newFrame1
            self.progress2.frame = self.newFrame2
            self.mistakes.frame = self.newMistakesFrame
            self.rightAnswers.frame = self.newRightAnswersFrame
        }
    }
    
    func noAnimate() {
        self.progress1.frame = self.newFrame1
        self.progress2.frame = self.newFrame2
        self.mistakes.frame = self.newMistakesFrame
        self.rightAnswers.frame = self.newRightAnswersFrame
    }

}
