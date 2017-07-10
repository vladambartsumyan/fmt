import Foundation
import RealmSwift

class Exercise: Object {
    dynamic var firstDigit: Int = -1
    dynamic var secondDigit: Int = -1
    dynamic private var _type: Int = 0
    
    var type: StageType {
        get { return StageType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    static func create(_ firstDigit: Int, _ secondDigit: Int = -1) -> Exercise {
        let exercise = Exercise()
        exercise.firstDigit = firstDigit
        exercise.secondDigit = secondDigit
        return exercise
    }
    
    func createExercisePassing() -> ExercisePassing {
        let exercisePassing = ExercisePassing()
        exercisePassing.exercise = self
        return exercisePassing
    }
}
