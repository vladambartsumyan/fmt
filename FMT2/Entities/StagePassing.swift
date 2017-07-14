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
                let exercisePassing = currentExercisePassing!
                exercises.remove(objectAtIndex: index)
                exercises.append(exercisePassing)
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
