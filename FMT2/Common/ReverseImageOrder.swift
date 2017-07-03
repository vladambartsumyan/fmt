import Foundation

class ReverseImageOrder {
    
    static func check(firstDigit: Int, secondDigit: Int) -> Bool {
        return [(4, 7), (7, 4)].reduce(false){ $0.0 || ($0.1.0 == firstDigit && $0.1.1 == secondDigit) }
    }
}
