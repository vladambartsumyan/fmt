import Foundation

class GraphStatistic {
    var date: Date!
    var seconds: TimeInterval = 0.0
    var percentForSeconds: Double = 0.0
    var mistakes: Int = 0
    var rightAnswers: Int = 0
    var percentForMistakes: Double = 0.0
    var percentForRightAnswers: Double = 0.0
    var needAnimating = true
}
