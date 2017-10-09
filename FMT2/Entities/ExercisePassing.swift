import Foundation
import RealmSwift

class ExercisePassing: Object {
    @objc dynamic var exercise: Exercise!
    let elapsedTime = List<ElapsedTime>()
    let errors = List<GameError>()   
    @objc dynamic var passedAt = Date()
    @objc dynamic var isPassed = false
    
    
    func mistake() {
        let realm = try! Realm()
        try! realm.write {
            let gameError = GameError()
            realm.add(gameError)
            errors.append(gameError)
        }
    }
}
