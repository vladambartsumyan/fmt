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
        let oneDay: TimeInterval = 86400
        
        let realm = try! Realm()
        var result: [GraphStatistic] = []
    
        var maxTime: TimeInterval = 0
        var maxMistakesOrRightAnswers = 0
        
        var curDate = Date()
        
        let allExamExercises = realm.objects(StagePassing.self).filter{$0.stage.mode == .exam}.flatMap{$0.exercises}
        let allRightAnswers = allExamExercises.filter{$0.isPassed && !$0.passedAt.afterDay(date: curDate)}.map{$0.passedAt}.sorted(by: {$0.0 > $0.1})
        var indRA = 0
        let allMisatakes = allExamExercises.flatMap{$0.errors}.filter{!$0.date.afterDay(date: curDate)}.sorted(by: {$0.0.date > $0.1.date})
        var indM = 0
        let allElapsedTime = allExamExercises.flatMap{$0.elapsedTime}.filter{!$0.createdAt.afterDay(date: curDate)}.sorted(by: {$0.0.createdAt > $0.1.createdAt})
        var indET = 0

        while indRA < allRightAnswers.count || indM < allMisatakes.count || indET < allElapsedTime.count {
            result.append(GraphStatistic())
            result.last!.date = curDate
            while indRA < allRightAnswers.count && allRightAnswers[indRA].equalDayTo(date: curDate) {
                result.last!.rightAnswers += 1
                indRA += 1
            }
            while indM < allMisatakes.count && allMisatakes[indM].date.equalDayTo(date: curDate) {
                result.last!.mistakes += 1
                indM += 1
            }
            while indET < allElapsedTime.count && allElapsedTime[indET].createdAt.equalDayTo(date: curDate) {
                result.last!.seconds += allElapsedTime[indET].seconds
                indET += 1
            }
            curDate.addTimeInterval(-oneDay)
        }
        
        for day in result {
            if day.mistakes > maxMistakesOrRightAnswers {
                maxMistakesOrRightAnswers = day.mistakes
            }
            if day.rightAnswers > maxMistakesOrRightAnswers {
                maxMistakesOrRightAnswers = day.rightAnswers
            }
            if day.seconds > maxTime {
                maxTime = day.seconds
            }
        }
        
        for day in result {
            day.percentForMistakes = maxMistakesOrRightAnswers == 0 ? 1.0 : Double(day.mistakes) / Double(maxMistakesOrRightAnswers)
            day.percentForRightAnswers = maxMistakesOrRightAnswers == 0 ? 1.0 : Double(day.rightAnswers) / Double(maxMistakesOrRightAnswers)
            day.percentForSeconds = maxTime == 0 ? 1.0 : Double(day.seconds) / Double(maxTime)
        }
        
        return result
    }
}
