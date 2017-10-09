import Foundation
import RealmSwift

class Stage: Object {
    
    @objc dynamic private var _type: Int = 0
    @objc dynamic private var _mode: Int = 0
    @objc dynamic var numberOfExercises: Int = 0 
    let possibleExercises = List<Exercise>()
    
    var type: StageType {
        get { return StageType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    var mode: StageMode {
        get { return StageMode(rawValue: _mode)! }
        set { _mode = newValue.rawValue }
    }
    
    static func create(type: StageType, mode: StageMode, numberOfExercises: Int, possibleExercises: [Exercise]) -> Stage {
        let stage = Stage()
        stage.type = type
        stage.mode = mode
        stage.numberOfExercises = numberOfExercises
        for exercise in possibleExercises {
            stage.possibleExercises.append(exercise)
        }
        return stage
    }
    
    func createStagePassing() -> StagePassing {
        let stagePassing = StagePassing()
        stagePassing.stage = self
        if mode == .exam {
            let possibleExercisesCopy = Array(self.possibleExercises)
            var requiredExercises = [StageType.permutation.rawValue, StageType.training.rawValue].contains(_type) ? possibleExercisesCopy : Array(possibleExercisesCopy.dropLast(possibleExercisesCopy.count - numberOfExercises))
            var additionalExercises = [StageType.permutation.rawValue, StageType.training.rawValue].contains(_type) ? [] : Array(possibleExercisesCopy.dropFirst(numberOfExercises))
            let reqCount = [StageType.permutation.rawValue, StageType.training.rawValue].contains(_type) ? numberOfExercises : requiredExercises.count
            for _ in 0..<reqCount {
                let exercise = requiredExercises.eraseRandomElem()!
                stagePassing.exercises.append(exercise.createExercisePassing())
            }
            for _ in 0..<additionalExercises.count {
                let exercise = additionalExercises.eraseRandomElem()!
                stagePassing.exercises.append(exercise.createExercisePassing())
            }
        }
        if mode == .simple {
            for exercise in self.possibleExercises {
                stagePassing.exercises.append(exercise.createExercisePassing())
            }
        }
        return stagePassing
    }
    
}
