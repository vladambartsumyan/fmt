import Foundation
import RealmSwift

class ElapsedTime: Object {
    dynamic var createdAt = Date()
    dynamic var seconds: Double = 0.0
}
