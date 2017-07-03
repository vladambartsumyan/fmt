import UIKit

extension CGVector {

    static func length(vector: CGVector) -> CGFloat {
        return sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
    }
    
    static func angFromZero(vector: CGVector) -> CGFloat {
        let zeroVector = CGVector(dx: 1, dy: 0)
        let scolarMult = vector.dx * zeroVector.dx + vector.dy * zeroVector.dy
        let lengthMult = CGVector.length(vector: vector) * CGVector.length(vector: zeroVector)
        return acos(scolarMult / lengthMult)
    }
}
