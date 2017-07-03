import Foundation

extension Int {
    static func random(min: Int, max: Int) -> Int {
        guard max - min >= 0 else {
            return min
        }
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}
