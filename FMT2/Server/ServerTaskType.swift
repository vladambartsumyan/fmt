import Foundation
import Moya

enum ServerTaskType: Int {
    case registerDevice = 0
    case setColorForDigit = 1
    case introductionStatistic = 2
    case exerciseStatistic = 3
    case bonusStatistic = 4
    case timeForDay = 5
    case introductionFinished = 6
    case exerciseFinished = 7
    case startGame = 8
}
