import Foundation
import RealmSwift

class ExercisePassing: Object {
    dynamic var exercise: Exercise!
    let elapsedTime = List<ElapsedTime>()
    let errors = List<GameError>()   
    dynamic var passedAt = Date()
    dynamic var isPassed = false
    
    
    func mistake() {
        let realm = try! Realm()
        try! realm.write {
            let gameError = GameError()
            realm.add(gameError)
            errors.append(gameError)
        }
    }
}
