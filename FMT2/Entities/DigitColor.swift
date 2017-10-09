import Foundation
import RealmSwift

class DigitColor: Object {
    
    @objc dynamic var value: Int = 0
    @objc dynamic private var _color: String = ""
    
    var color: Color {
        get {
            return Color(rawValue: _color)!
        }
        set {
            _color = newValue.rawValue
        }
    }
    
    override class func primaryKey() -> String? {
        return "value"
    }
}
