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
    dynamic var mistakeCount = 3
    
    var type: StageType {
        get { 
            if _type == StageType.training.rawValue {
                return currentStagePassing?.currentExercisePassing != nil ? currentStagePassing!.currentExercisePassing!.exercise!.type : .training 
            }
            return StageType(rawValue: _type)! 
        }
        set { _type = newValue.rawValue }
    }
    
    var typeOfNextExercise: StageType? {
        return nextExercisePassing?.exercise.type
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
        let result: MistakeResult = mistakeCountInExam == mistakeCount - 1 ? .soMuch : .normal
        if inGame || currentStagePassing!.stage.mode == .exam {
            currentStagePassing?.mistake()
        }
        return result
    }
    
    func sendStatistic() {
        if inGame || currentStagePassing!.stage.mode == .exam { 
            
            let stage = currentStagePassing!.stage
            let curExercisePassing = currentStagePassing!.currentExercisePassing!
            
            if stage!.mode == .simple && stage!.type == .introduction {
                ServerTaskManager.pushBack(.introductionStatistic(
                    countError: curExercisePassing.errors.count, 
                    digit: curExercisePassing.exercise.firstDigit)
                )
            }
            if stage!.mode == .simple && stage!.type != .introduction {
                ServerTaskManager.pushBack(.exerciseStatistic(
                    countError: curExercisePassing.errors.count, 
                    firstDigit: curExercisePassing.exercise.firstDigit, 
                    secondDigit: curExercisePassing.exercise.secondDigit, 
                    time: curExercisePassing.elapsedTime.reduce(0.0){$0.0 + $0.1.seconds})
                )
            }
            if stage!.mode == .exam {
                ServerTaskManager.pushBack(.bonusStatistic(
                    countError: curExercisePassing.errors.count, 
                    firstDigit: curExercisePassing.exercise.firstDigit, 
                    secondDigit: curExercisePassing.exercise.secondDigit, 
                    time: curExercisePassing.elapsedTime.reduce(0.0){$0.0 + $0.1.seconds})
                )           
            }
        }
    }
    
    func rightAnswer() {
        sendStatistic()
        if currentStagePassing!.index == currentStagePassing!.exercises.count - 1 {
            try! (try! Realm()).write {
                currentStagePassing!.currentExercisePassing!.isPassed = true
                currentStagePassing!.currentExercisePassing!.passedAt = Date()
                currentStagePassing!.index += 1
                index += 1
            }
        } else {
            try! (try! Realm()).write {
                currentStagePassing!.currentExercisePassing!.isPassed = true
                currentStagePassing!.currentExercisePassing!.passedAt = Date()
                currentStagePassing!.index += 1
            }
        }
    }
    
    var rightAnswerResult: RightAnswerResult {
        if currentStagePassing!.index == currentStagePassing!.exercises.count - 1 {
            return index == stagesPassing.count - 1 ? .endOfGlobalStage : .endOfStage 
        } else {
            return .normal
        }
    }
    
    var nextExercisePassing: ExercisePassing? {
        let nextExerciseIndex = currentStagePassing!.index + 1
        if nextExerciseIndex < currentStagePassing!.exercises.count {
            return currentStagePassing!.exercises[nextExerciseIndex]
        } else {
            let nextStageIndex = index + 1
            if nextStageIndex < stagesPassing.count {
                return stagesPassing[nextStageIndex].exercises[0]
            } else {
                return nil
            }
        }
    }
    
    var mistakeCountInExam: Int {
        return stagesPassing.reduce(0){ $0.1.stage.mode == .exam ? $0.0 + $0.1.exercises.reduce(0){ $0.0 + $0.1.errors.count } : $0.0 }
    }
    
    func reset() {
        let realm = try! Realm()
        try! realm.write {
            index = 0
            if !inGame {
                for ind in 0..<stagesPassing.count {
                    if stagesPassing[ind].stage.mode == .exam {
                        stagesPassing[ind] = stagesPassing[ind].stage.createStagePassing()
                        for exercisePassing in stagesPassing[ind].exercises {
                            realm.add(exercisePassing)
                        }
                        realm.add(stagesPassing[ind])
                    } else {
                        stagesPassing[ind].index = 0
                    }
                }
            } else {
                for ind in 0..<stagesPassing.count {
                    stagesPassing[ind] = stagesPassing[ind].stage.createStagePassing()
                    for exercisePassing in stagesPassing[ind].exercises {
                        realm.add(exercisePassing)
                    }
                    realm.add(stagesPassing[ind])
                }
            }
        }          
    }
    
    func addElapsedTime() {
        if inGame || currentStagePassing!.stage.mode == .exam {
            let realm = try! Realm()
            try! realm.write {
                let elapsedTime = ElapsedTime()
                realm.add(elapsedTime)
                currentStagePassing!.currentExercisePassing?.elapsedTime.append(elapsedTime)
            }
        }
    }
    
    func updateElapsedTime() {
        if inGame || currentStagePassing!.stage.mode == .exam {
            let realm = try! Realm()
            try! realm.write {
                if let elapsedTime = currentStagePassing!.currentExercisePassing!.elapsedTime.last {
                    let now = Date()
                    elapsedTime.seconds += now.timeIntervalSince(elapsedTime.createdAt)
                    elapsedTime.createdAt = now
                }
            }
        }
    }
    
    func saveStages() {
        for stagePassing in stagesPassing {
            if stagePassing.stage.mode == .exam {
                stagePassing.save() 
            }
        }
    }
}
