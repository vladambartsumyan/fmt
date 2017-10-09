import UIKit
import SMSegmentView
import SVGKit
class MoreStatisticVC: UIViewController, SMSegmentViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var segmentView: UIView!
    
    @IBOutlet weak var background: UIImageView!
    var statisticByDays: [GraphStatistic]! = Statistic.byDays
    
    private let borderWidth: CGFloat = 2
    
    var leftBorder: CAShapeLayer!
    var rightBorder: CAShapeLayer!
    var glow: CAShapeLayer!
    
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    
    var greenColor = UIColor(red255: 55, green: 204, blue: 76)
    var greenBorderColor = UIColor.init(red255: 31, green: 134, blue: 46)
    var shadowColor = UIColor.init(white: 0, alpha: 13/255)
    var grayBorderColor = UIColor.init(white: 0.5, alpha: 1.0)
    var glowColor = UIColor.init(red255: 215, green: 245, blue: 219)
    
    var segment: SMSegmentView!
    var segment1: SMSegment!
    var segment2: SMSegment!
    
    var selectedIndex: Int = 0
    var numberOfColumnForPage: Int = 6
    
    private let timeCellReuseID = "timeCellReuseID"
    private let sideCellReuseID = "sideCellReuseID"
    private let mistakesAndRightAnswersCellReuseId = "mistakesAndRightAnswersCellReuseId"
    private let footerViewReuseID = "footerViewReuseID"
    private let headerViewReuseID = "headerViewReuseID"
    private let emptyCellReuseID = "emptyCellReuseID"

    @IBOutlet weak var graph: UICollectionView!
    
    @IBOutlet weak var dismissButton: TopButton!
    
    @IBOutlet weak var header: UILabel!
    
    var cellSize: CGSize!
    var sideCellSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = SVGKImage(named: "background").uiImage
        configureTopBar()
        configureGraph()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GAManager.track(screen: .statisticDetail)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initSizes()
        configureSegmentView()
        graph.transform = CGAffineTransform.init(scaleX: -1, y: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTopBar() {
        dismissButton.setIcon(withName: "LeftArrowButton")
    }
    
    func initSizes() {
        self.cellSize = CGSize.init(width: graph.frame.width / (CGFloat(numberOfColumnForPage) + 0.5), height: graph.frame.height)
        self.sideCellSize = CGSize.init(width: cellSize.width * 0.25, height: graph.frame.height)
    }
    
    func configureGraph() {
        graph.alwaysBounceHorizontal = true
        graph.register(TimeRatingCell.self, forCellWithReuseIdentifier: timeCellReuseID)
        graph.register(UINib.init(nibName: "TimeRatingCell", bundle: nil), forCellWithReuseIdentifier: timeCellReuseID)
        
        graph.register(EmptyCell.self, forCellWithReuseIdentifier: emptyCellReuseID)
        graph.register(UINib.init(nibName: "EmptyCell", bundle: nil), forCellWithReuseIdentifier: emptyCellReuseID)
        
        graph.register(MistakesAndRightAnswersCell.self, forCellWithReuseIdentifier: mistakesAndRightAnswersCellReuseId)
        graph.register(UINib.init(nibName: "MistakesAndRightAnswersCell", bundle: nil), forCellWithReuseIdentifier: mistakesAndRightAnswersCellReuseId)
        
        graph.register(FooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseID)
        graph.register(UINib.init(nibName: "FooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseID)
        
        
        graph.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewReuseID)
        graph.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewReuseID)
    }
    
    func configureSegmentView() {
        var frame = segmentView.bounds
        frame.origin = CGPoint.zero
        segmentView.layer.cornerRadius = segmentView.frame.height / 2
        
        segment?.removeFromSuperview()
        segment = SMSegmentView(frame: frame, separatorColour: .clear, separatorWidth: 0, segmentProperties: nil)
        
        segmentView.addSubview(segment)
        segment.segmentOnSelectionColour = UIColor.white
        segment.segmentOffSelectionColour = greenColor
        segment.separatorWidth = borderWidth
        segment.separatorColour = greenBorderColor
        
        
        segment1 = segment.addSegmentWithTitle(title: "", onSelectionImage: nil, offSelectionImage: nil)
        segment2 = segment.addSegmentWithTitle(title: "", onSelectionImage: nil, offSelectionImage: nil)
        
        self.segment.selectSegmentAtIndex(index: selectedIndex)
        
        leftLabel = UILabel()
        leftLabel.isUserInteractionEnabled = false
        rightLabel = UILabel()
        rightLabel.isUserInteractionEnabled = false
        
        var shadowFrame = segmentView.frame
        shadowFrame.origin = CGPoint(x: 0, y: 13/90 * segmentView.frame.height + borderWidth)
        let shadowView = UIView(frame: shadowFrame)
        shadowView.backgroundColor = shadowColor
        shadowView.layer.cornerRadius = shadowView.frame.height / 2
        shadowView.isUserInteractionEnabled = false
        
        segment.addSubview(shadowView)
        segment.addSubview(leftLabel)
        segment.addSubview(rightLabel)
        
        let layerLeft = CAShapeLayer()
        layerLeft.path = makeLeftBorder(frame: segmentView.bounds).cgPath
        segment.layer.addSublayer(layerLeft)
        
        let layerRight = CAShapeLayer()
        layerRight.path = makeRightBorder(frame: segmentView.bounds).cgPath
        segment.layer.addSublayer(layerRight)
        
        let glow = CAShapeLayer()
        glow.path = makeGlowPath(frame: segmentView.bounds).cgPath
        segment.layer.addSublayer(glow)
        
        self.glow = glow
        self.leftBorder = layerLeft
        self.rightBorder = layerRight
        
        configureColorsForSegmentView(index: selectedIndex)
        
        segment.delegate = self
    }
    
    func makeLeftBorder(frame: CGRect) -> UIBezierPath {
        let radius = frame.height / 2
        let center = CGPoint(x: radius, y: radius)
        
        let path = UIBezierPath()
        
        var point = CGPoint(x: frame.width / 2, y: frame.height)
        path.move(to: point)
        
        point = CGPoint(x: radius, y: frame.height)
        path.addLine(to: point)
        
        path.addArc(withCenter: center, radius: radius, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi / 2, clockwise: true)
        
        point = CGPoint(x: frame.width / 2, y: 0)
        path.addLine(to: point)
        
        point = CGPoint(x: frame.width / 2, y: borderWidth)
        path.addLine(to: point)
        
        point = CGPoint(x: radius, y: borderWidth)
        path.addLine(to: point)
        
        path.addArc(withCenter: center, radius: radius - borderWidth, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: false)
        
        point = CGPoint(x: frame.width / 2, y: frame.height - borderWidth)
        path.addLine(to: point)
        
        point = CGPoint(x: frame.width / 2, y: frame.height)
        path.addLine(to: point)
        
        return path
    }
    
    func makeRightBorder(frame: CGRect) -> UIBezierPath {
        let radius = frame.height / 2
        let center = CGPoint(x: frame.width - radius, y: radius)
        
        let path = UIBezierPath()
        
        var point = CGPoint(x: frame.width / 2, y: frame.height)
        path.move(to: point)
        
        point = CGPoint(x: frame.width - radius, y: frame.height)
        path.addLine(to: point)
        
        path.addArc(withCenter: center, radius: radius, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi / 2, clockwise: false)
        
        point = CGPoint(x: frame.width / 2, y: 0)
        path.addLine(to: point)
        
        point = CGPoint(x: frame.width / 2, y: borderWidth)
        path.addLine(to: point)
        
        point = CGPoint(x: frame.width - radius, y: borderWidth)
        path.addLine(to: point)
        
        path.addArc(withCenter: center, radius: radius - borderWidth, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        
        point = CGPoint(x: frame.width / 2, y: frame.height - borderWidth)
        path.addLine(to: point)
        
        point = CGPoint(x: frame.width / 2, y: frame.height)
        path.addLine(to: point)
        
        return path
    }
    
    func makeGlowPath(frame: CGRect) -> UIBezierPath {
        let radius = frame.height / 2
        let center = CGPoint(x: radius, y: radius)
        let point = CGPoint(x: radius, y: 2.5 * borderWidth)
        
        let path = UIBezierPath()
        
        path.move(to: point)
        
        path.addArc(withCenter: center, radius: radius - 2.5 * borderWidth, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi * 5 / 6, clockwise: false)
        
        let distanceBetweenCenters = radius
        let bigCenter = center + CGPoint(x: distanceBetweenCenters * cos(CGFloat.pi / 3), y: distanceBetweenCenters * sin(CGFloat.pi / 3))
        let bigRadius = CGVector.length(vector: bigCenter - path.currentPoint) 
        path.addArc(withCenter: bigCenter, radius: bigRadius, startAngle: -CGVector.angFromZero(vector: path.currentPoint - bigCenter), endAngle: -CGVector.angFromZero(vector: point - bigCenter), clockwise: true)

        path.addLine(to: point)
        
        path.close()
        
        return path
    }
    
    func createAttributedText(fromString string: String, strokeColor: UIColor, sizeForIPhone7Plus size: CGFloat) -> NSAttributedString {
        let attrStr = NSMutableAttributedString.init(string: string)
        let attributes: [NSAttributedStringKey : Any] = [
                .strokeWidth : -4,
                .strokeColor : strokeColor,
                .font : UIFont.init(name: "Lato-Black", size: size * UIScreen.main.bounds.width / 414.0)!,
                .foregroundColor : UIColor.white
            ]
        attrStr.addAttributes(attributes, range: NSRange.init(location: 0, length: string.characters.count))
        return attrStr
    }
    
    func segmentView(segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        SoundHelper.playDefault()
        selectedIndex = index
        graph.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        self.statisticByDays = Statistic.byDays
        graph.reloadData()
        configureColorsForSegmentView(index: index)
        
    }
    
    func configureColorsForSegmentView(index: Int) {
        if index == 0 {
            header.attributedText = createAttributedText(fromString: "Тренажёр", strokeColor: UIColor.init(white: 100/255, alpha: 1), sizeForIPhone7Plus: 30)
            leftBorder.fillColor = grayBorderColor.cgColor
            rightBorder.fillColor = greenBorderColor.cgColor
            leftLabel.attributedText = createAttributedText(fromString: "По тренажёру", strokeColor: grayBorderColor, sizeForIPhone7Plus: 22)
            rightLabel.attributedText = createAttributedText(fromString: "По времени", strokeColor: greenBorderColor, sizeForIPhone7Plus: 22)
            leftLabel.sizeToFit()
            leftLabel.center = segment1.center
            rightLabel.sizeToFit()
            rightLabel.center = segment2.center
            glow.fillColor = UIColor.white.cgColor
        } else {
            header.attributedText = createAttributedText(fromString: "Время использования", strokeColor: UIColor.init(white: 100/255, alpha: 1), sizeForIPhone7Plus: 30)
            rightBorder.fillColor = grayBorderColor.cgColor
            leftBorder.fillColor = greenBorderColor.cgColor
            leftLabel.attributedText = createAttributedText(fromString: "По тренажёру", strokeColor: greenBorderColor, sizeForIPhone7Plus: 22)
            rightLabel.attributedText = createAttributedText(fromString: "По времени", strokeColor: grayBorderColor, sizeForIPhone7Plus: 22)
            leftLabel.sizeToFit()
            leftLabel.center = segment1.center
            rightLabel.sizeToFit()
            rightLabel.center = segment2.center
            glow.fillColor = glowColor.cgColor
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        let vc = GeneralStatisticVC(nibName: "GeneralStatisticVC", bundle: nil)
        AppDelegate.current.setRootVC(vc)
    }
    
    // Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return statisticByDays.count
        } else {
            return max(numberOfColumnForPage - statisticByDays.count, 0) 
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = graph.dequeueReusableCell(withReuseIdentifier: emptyCellReuseID, for: indexPath) as! EmptyCell
            return cell
        }
        if segment.indexOfSelectedSegment == 0 {
            let cell = graph.dequeueReusableCell(withReuseIdentifier: mistakesAndRightAnswersCellReuseId, for: indexPath) as! MistakesAndRightAnswersCell
            cell.configureWith(graphStatistic: statisticByDays[indexPath.row])
            return cell
        } else {
            let cell = graph.dequeueReusableCell(withReuseIdentifier: timeCellReuseID, for: indexPath) as! TimeRatingCell
            cell.configureWith(graphStatistic: statisticByDays[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        if let cell = cell as? AnimateAndNoAnimate, indexPath.section == 0 {
            if statisticByDays[indexPath.row].needAnimating {
                cell.animate()
                statisticByDays[indexPath.row].needAnimating = false
            } else {
                cell.noAnimate()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseID, for: indexPath) as! FooterView
            footer.transform = CGAffineTransform.init(scaleX: -1, y: 1)
            return footer
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewReuseID, for: indexPath) as! HeaderView
            header.transform = CGAffineTransform.init(scaleX: -1, y: 1)
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.zero : sideCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? sideCellSize : CGSize.zero
    }
}
