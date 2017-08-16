import Foundation

enum TrackingScreen: String {
    case startScreen = "Стартовый экран"
    case menu = "Меню"
    case stageMap = "Карта уровней"
    case introduction = "Знакомство"
    case multBy0 = "Умножение на 0"
    case multBy1 = "Умножение на 1"
    case multBy10 = "Умножение на 10"
    case multBy2 = "Умножение на 2"
    case multBy3 = "Умножение на 3" 
    case multBy4 = "Умножение на 4"
    case multBy5 = "Умножение на 5"
    case multBy6 = "Умножение на 6"
    case multBy7 = "Умножение на 7"
    case multBy8 = "Умножение на 8"
    case multBy9 = "Умножение на 9"
    case permutation = "Перестановка множителей"
    case training = "Тренировка"
    case statistic = "Статистика"
    case statisticDetail = "Детальная статистика экзамена"
    case tutorial = "Обучающий экран"
    
    var name: String {
        return self.rawValue
    }
}
