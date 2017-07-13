import Foundation
import RealmSwift

class Statistic {
    
    let globalStagesPassing = Game.current.globalStagesPassing
    let allStagesPassing = Game.current.stagesPassing

    var introductionSimpleStagesPassing: [StagePassing]!
    var exercisesSimpleStagesPassing: [StagePassing]!
    var examStagesPassing: [StagePassing]!
    
    func updateIntroductionSimpleStagesPassingIfNeeded() {
        if introductionSimpleStagesPassing == nil {
            introductionSimpleStagesPassing = allStagesPassing.filter{$0.stage.type == .introduction && $0.stage.mode == .simple}
        }
    }
    
    func updateExercisesSimpleStagesPassingIfNeeded() {
        if exercisesSimpleStagesPassing == nil {
            exercisesSimpleStagesPassing = allStagesPassing.filter{$0.stage.type != .introduction && $0.stage.mode == .simple}
        }
    }
    
    func updateExamStagesPassingIfNeeded() {
        if examStagesPassing == nil {
            examStagesPassing = allStagesPassing.filter{$0.stage.mode == .exam}
        }
    }
    
    var introductionProgress: (Int, Int) {
        let currentIntroductionStagePassing = globalStagesPassing.filter{$0.type == .introduction}.flatMap{$0.stagesPassing.filter{$0.stage.mode == .simple}}.first!
        return (currentIntroductionStagePassing.index, currentIntroductionStagePassing.exercises.count)
    }
    
    var introductionMistakeCount: Int {
        updateIntroductionSimpleStagesPassingIfNeeded()
        return introductionSimpleStagesPassing.flatMap{$0.exercises}.reduce(0){$0.0 + $0.1.errors.count}
    }
    
    var exerciseProgress: (Int, Int) {
        let currentExercisesSimpleStagesPassing = globalStagesPassing.flatMap{$0.stagesPassing}.filter{$0.stage.type != .introduction && $0.stage.mode == .simple}
        let passedCount = currentExercisesSimpleStagesPassing.reduce(0){$0.0 + $0.1.index}
        let totalCount = currentExercisesSimpleStagesPassing.reduce(0){$0.0 + $0.1.exercises.count}
        return (passedCount, totalCount)
    }
    
    var exerciseElapsedTime: TimeInterval {
        updateExercisesSimpleStagesPassingIfNeeded()
        return exercisesSimpleStagesPassing.flatMap{$0.exercises}.flatMap{$0.elapsedTime}.map{$0.seconds}.reduce(0.0){$0.0 + $0.1}
    }
    
    var exerciseMistakeCount: Int {
        updateExercisesSimpleStagesPassingIfNeeded()
        return exercisesSimpleStagesPassing.flatMap{$0.exercises}.flatMap{$0.errors.count}.reduce(0){$0.0 + $0.1}
    }
    
    var examElapsedTime: TimeInterval {
        updateExamStagesPassingIfNeeded()
        return examStagesPassing.flatMap{$0.exercises}.flatMap{$0.elapsedTime}.map{$0.seconds}.reduce(0.0){$0.0 + $0.1}
    }
    
    var examPassedCount: Int {
        updateExamStagesPassingIfNeeded()
        return examStagesPassing.reduce(0){$0.0 + $0.1.index}
    }
    
    var examMistakeCount: Int {
        updateExamStagesPassingIfNeeded()
        return examStagesPassing.flatMap{$0.exercises}.flatMap{$0.errors.count}.reduce(0){$0.0 + $0.1}
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
