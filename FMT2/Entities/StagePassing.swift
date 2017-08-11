import Foundation
import RealmSwift

class StagePassing: Object {
    dynamic var stage: Stage!
    let exercises = List<ExercisePassing>()
    dynamic var index = 0
    
    var passed: Bool {
        return index >= exercises.count
    }
    
    var currentExercisePassing: ExercisePassing? {
        guard index < exercises.count else {
            return nil
        }
        return exercises[index]
    }
    
    func mistake() {
        currentExercisePassing?.mistake()
        if stage.mode == .exam {
            let realm = try! Realm()
            try! realm.write {
                if index < stage.numberOfExercises {
                    let exercisePassing = exercises[index]
                    exercises.remove(objectAtIndex: index)
                    exercises.insert(exercisePassing, at: stage.numberOfExercises - 1)
                } else {
                    let exercisePassing = exercises[index]
                    exercises.remove(objectAtIndex: index)
                    exercises.insert(exercisePassing, at: exercises.count)
                }
            }
        }
    }
    
    func save() {
        let realm = try! Realm()
        try! realm.write {
            for exercisePassing in exercises {
                realm.add(exercisePassing)
            }
            realm.add(self)
        }
    }
}
