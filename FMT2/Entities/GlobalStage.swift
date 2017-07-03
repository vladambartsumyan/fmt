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
        return globalStagePassing
    }
}
