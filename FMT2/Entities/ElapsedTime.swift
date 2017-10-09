import Foundation
import RealmSwift

class ElapsedTime: Object {
    @objc dynamic var createdAt = Date()
    @objc dynamic var seconds: Double = 0.0
}
