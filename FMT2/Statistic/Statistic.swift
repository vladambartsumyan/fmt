import Foundation
import RealmSwift

class Statistic {
    
//    var introductionLevels = (try! Realm()).objects(Level.self).filter("stage == 0")
//    var exerciseLevels = (try! Realm()).objects(Level.self).filter("stage == 1")
//    var bonusLevels = (try! Realm()).objects(Level.self).filter("stage > 1")
    
    var introductionProgress: CGFloat {
//        let floatPassedIntroductionLevelCount = CGFloat(introductionPassedCount)
//        let floatIntroductionLevelNumber = CGFloat(GameStage.introduction.levelsNumber)
        //        return floatPassedIntroductionLevelCount / floatIntroductionLevelNumber
        return 1
    }
    
    var introductionMistakeCount: Int {
//        var res = 0
//        for level in introductionLevels {
//            res += level.mistakes.count
//        }
        //        return res
        return 1
    }
    
    var introductionPassedCount: Int {
        //        return introductionLevels.filter("passed == true").count
        return 1
    }
    
    var exerciseProgress: CGFloat {
//        let floatPassedExerciseLevelCount = CGFloat(exerciseLevels.filter("passed == true").count)
//        let floatExerciseLevelNumber = CGFloat(GameStage.exercise.levelsNumber)
        //        return floatPassedExerciseLevelCount / floatExerciseLevelNumber
        return 1
    }
    
    var exerciseElapsedTime: TimeInterval {
//        var res = 0.0
//        for level in exerciseLevels {
//            res += level.seconds
//        }
        //        return res
        return 1
    }
    
    var exerciseMistakeCount: Int {
//        var res = 0
//        for level in exerciseLevels {
//            res += level.mistakes.count
//        }
        //        return res
        return 1
    }
    
    var exercisePassedCount: Int {
        //        return exerciseLevels.filter("passed == true").count
        return 1
    }
    
    var bonusElapsedTime: TimeInterval {
//        var res = 0.0
//        for level in bonusLevels {
//            res += level.seconds
//        }
//        return res
        return 1
    }
    
    var bonusPassedCount: Int {
//        return bonusLevels.filter("passed == true").count
        return 1
    }
    
    var bonusMistakeCount: Int {
//        var res = 0
//        for level in bonusLevels {
//            res += level.mistakes.count
//        }
//        return res
        return 1
    }
    
    static var byDays: [GraphStatistic] {
//        let oneDay: TimeInterval = 86400
//        
//        let realm = try! Realm()
//        let allLevels: [Level] = realm.objects(Level.self).reversed()
//        let allElapsedTimes: [ElapsedTime] = realm.objects(ElapsedTime.self).sorted(byKeyPath: "updatedAt").reversed()
//        let allMistakes: [Mistake] = realm.objects(Mistake.self).sorted(byKeyPath: "created").reversed()
//        
//        if allLevels.count == 0 {
//            return []
//        }
//        
//        var result: [GraphStatistic] = []
//        
//        var maxTime: TimeInterval = 0
//        var maxMistakesOrRightAnswers = 0
//        
//        let startDate = Date()
//        var date = startDate
//        let newGameDate = allLevels.last!.startedAt
//
//        while !date.beforeDay(date: newGameDate) {
//            result.append(GraphStatistic())
//            result.last!.date = date
//            date = date.addingTimeInterval(-oneDay)
//        }
//        
//        var indMistakes = 0
//        date = startDate
//        
//        for day in result {
//            while indMistakes < allMistakes.count && day.date.equalDayTo(date: allMistakes[indMistakes].created) {
//                day.mistakes += 1
//                indMistakes += 1
//            }
//        }
//        
//        var indElapsedTimes = 0
//        for day in result {
//            while indElapsedTimes < allElapsedTimes.count && day.date.equalDayTo(date: allElapsedTimes[indElapsedTimes].created) {
//                day.seconds += allElapsedTimes[indElapsedTimes].seconds
//                indElapsedTimes += 1
//            }
//        }
//        
//        var indLevel = 0
//        for day in result {
//            while indLevel < allLevels.count && day.date.equalDayTo(date: allLevels[indLevel].passedAt) {
//                if allLevels[indLevel].passed {
//                    day.rightAnswers += 1
//                }
//                indLevel += 1
//            }
//        }
//        
//        for day in result {
//            if day.mistakes > maxMistakesOrRightAnswers {
//                maxMistakesOrRightAnswers = day.mistakes
//            }
//            if day.rightAnswers > maxMistakesOrRightAnswers {
//                maxMistakesOrRightAnswers = day.rightAnswers
//            }
//            if day.seconds > maxTime {
//                maxTime = day.seconds
//            }
//        }
//        
//        for day in result {
//            day.percentForMistakes = maxMistakesOrRightAnswers == 0 ? 1.0 : Double(day.mistakes) / Double(maxMistakesOrRightAnswers)
//            day.percentForRightAnswers = maxMistakesOrRightAnswers == 0 ? 1.0 : Double(day.rightAnswers) / Double(maxMistakesOrRightAnswers)
//            day.percentForSeconds = maxTime == 0 ? 1.0 : Double(day.seconds) / Double(maxTime)
//        }
//        
//        return result
        return []
    }
}
