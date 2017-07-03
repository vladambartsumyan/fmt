import Foundation
import Moya

enum ServerTaskType: Int {
    case registerDevice = 0
    case setColorForDigit
    case introductionStatistic
    case exerciseStatistic
    case bonusStatistic
    case timeForDay
    case introductionFinished
    case exerciseFinished
    case startGame
}
