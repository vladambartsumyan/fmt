import RealmSwift

enum RightAnswerResult {
    case normal
    case endOfStage
    case endOfGlobalStage
}

enum MistakeResult {
    case normal
    case soMuch
}

class GlobalStagePassing: Object {
    
    dynamic var globalStage: GlobalStage!
    let stagesPassing = List<StagePassing>()
    dynamic var index = 0
    dynamic var inGame = true
    dynamic var _type = 0 
    
    var type: StageType {
        get { return StageType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    var isPassed: Bool {
        return index >= stagesPassing.count
    }
    
    var progress: Double {
        let passedExercises = stagesPassing.reduce(0){$0.0 + $0.1.index}
        let totalExercises = stagesPassing.reduce(0){$0.0 + $0.1.exercises.count}
        return Double(passedExercises) / Double(totalExercises)
    }
    
    var nextProgress: Double {
        let passedExercises = stagesPassing.reduce(0){$0.0 + $0.1.index}
        let totalExercises = stagesPassing.reduce(0){$0.0 + $0.1.exercises.count}
        return Double(passedExercises + 1) / Double(totalExercises)
    }
    
    var currentStagePassing: StagePassing? {
        guard index < stagesPassing.count else {
            return nil
        }
        return stagesPassing[index]
    }
    
    func mistake() -> MistakeResult {
        let result: MistakeResult = mistakeCountInExam % 3 == 2 ? .soMuch : .normal
        currentStagePassing?.mistake()
        return result
    }
    
    func rightAnswer() -> RightAnswerResult {
        if currentStagePassing!.index == currentStagePassing!.exercises.count - 1 {
            let result: RightAnswerResult = index == stagesPassing.count - 1 ? .endOfGlobalStage : .endOfStage 
            currentStagePassing?.rightAnswer()
            try! (try! Realm()).write {
                index += 1
            }
            return result
        } else {
            currentStagePassing?.rightAnswer()
            return .normal
        }
    }
    
    var mistakeCountInExam: Int {
        return stagesPassing.reduce(0){ $0.1.stage.mode == .exam ? $0.0 + $0.1.exercises.reduce(0){ $0.0 + $0.1.errors.count } : $0.0 }
    }
    
    func reset() {
        try! (try! Realm()).write {
            index = 0
            for ind in 0..<stagesPassing.count {
                if stagesPassing[ind].stage.mode == .exam {
                    stagesPassing[ind] = stagesPassing[ind].stage.createStagePassing()
                } else {
                    stagesPassing[ind].index = 0
                }
            }
        }        
    }
    
    func addElapsedTime() {
        let realm = try! Realm()
        try! realm.write {
            let elapsedTime = ElapsedTime()
            realm.add(elapsedTime)
            currentStagePassing!.currentExercisePassing?.elapsedTime.append(elapsedTime)
        }
    }
    
    func updateElapsedTime() {
        let realm = try! Realm()
        try! realm.write {
            let elapsedTime = currentStagePassing!.currentExercisePassing!.elapsedTime.last!
            let now = Date()
            elapsedTime.seconds += now.timeIntervalSince(elapsedTime.createdAt)
            elapsedTime.createdAt = now
        }
    }
}
