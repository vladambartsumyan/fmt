import UIKit

extension CGPoint {
    static func +(first: CGPoint, second: CGPoint) -> CGPoint {
        return CGPoint(x: first.x + second.x, y: first.y + second.y)
    }

    static func -(first: CGPoint, second: CGPoint) -> CGPoint {
        return CGPoint(x: first.x - second.x, y: first.y - second.y)
    }

    static func -(first: CGPoint, second: CGPoint) -> CGVector {
        return CGVector(dx: first.x - second.x, dy: first.y - second.y)
    }

    static func +(point: CGPoint, vector: CGVector) -> CGPoint {
        return CGPoint(x: point.x + vector.dx, y: point.y + vector.dy)
    }
}
