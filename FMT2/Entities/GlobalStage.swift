import RealmSwift

class GlobalStage: Object {
    dynamic private var _type: Int = 0
    let stages = List<Stage>()
    
    var type: StageType {
        get { return StageType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    static func create(stages: [Stage], type: StageType) -> GlobalStage {
        let globalStage = GlobalStage() 
        globalStage.type = type
        for stage in stages {
            globalStage.stages.append(stage)
        }
        return globalStage
    }
    
    func createGlobalStagePassing() -> GlobalStagePassing {
        let globalStagePassing = GlobalStagePassing()
        globalStagePassing._type = self._type
        globalStagePassing.globalStage = self
        for stage in self.stages {
            globalStagePassing.stagesPassing.append(stage.createStagePassing())
        }
        if type == .training {
            globalStagePassing.mistakeCount = 0
        }
        return globalStagePassing
    }
    
    static func createTrainingGlobalStage() -> GlobalStage {
        var possibleExercises: [Exercise] = []
        let globalStagesPassing = Game.current.globalStagesPassing.filter {
            $0._type != StageType.introduction.rawValue && $0.isPassed
        }
        for item in globalStagesPassing {
            let notExamStages: [Stage] = item.globalStage.stages.filter{$0.mode != .exam}
            for stage in notExamStages {
                for exercise in stage.possibleExercises {
                    possibleExercises.append(exercise)
                }
            }
        }
        let stage = Stage.create(type: .training, mode: .exam, numberOfExercises: 2, possibleExercises: possibleExercises)
        let training = create(stages: [stage], type: .training)
        return training
    }
}
