import UIKit

class TimeRatingCell: UICollectionViewCell, AnimateAndNoAnimate {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var line: UIImageView!
    
    var newFrame: CGRect!
    var newTimeFrame: CGRect!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.progress.backgroundColor = UIColor.init(red255: 124, green: 179, blue: 254)
    }

    func configureWith(graphStatistic: GraphStatistic) {
        self.layoutIfNeeded()
        self.layoutSubviews()
        time.text = graphStatistic.seconds.toTimeStringHM
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        date.text = dateFormatter.string(from: graphStatistic.date)
        
        let oldFrame = CGRect.init(x: line.frame.width, y: line.frame.height - 20, width: self.frame.width - line.frame.width, height: 20)
        self.progress.frame = oldFrame
        
        let oldTimeFrame = CGRect(
            x: oldFrame.origin.x, 
            y: oldFrame.origin.y - 20, 
            width: oldFrame.width, 
            height: 20
        )
        self.time.frame = oldTimeFrame
        
//        height.constant = 20 + (line.frame.height - 40.0) * CGFloat(graphStatistic.percentForSeconds)
        self.newFrame = CGRect(
            x: line.frame.width, 
            y: 20 + (line.frame.height - 40) * (1 - CGFloat(graphStatistic.percentForSeconds)), 
            width: self.frame.width - line.frame.width, 
            height: 20 + (line.frame.height - 40) * CGFloat(graphStatistic.percentForSeconds)
        )
        
        self.newTimeFrame = CGRect(
            x: newFrame.origin.x, 
            y: newFrame.origin.y - 20, 
            width: newFrame.width, 
            height: 20
        )
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5) { 
            self.progress.frame = self.newFrame
            self.time.frame = self.newTimeFrame
        }
    }
    
    func noAnimate() {
        self.progress.frame = self.newFrame
        self.time.frame = self.newTimeFrame
    }
}
