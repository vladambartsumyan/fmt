import Foundation

enum StageType: Int {
    case introduction = 0
    case multiplicationBy0
    case multiplicationBy1
    case multiplicationBy10
    case multiplicationBy2
    case multiplicationBy3
    case multiplicationBy4
    case multiplicationBy5
    case multiplicationBy6
    case multiplicationBy7
    case multiplicationBy8
    case multiplicationBy9
    case permutation
    case training
    
    var string: String {
        switch self {
        case .introduction:
            return "introduction"
        case .multiplicationBy0:
            return "multiplicationBy0"
        case .multiplicationBy1:
            return "multiplicationBy1"
        case .multiplicationBy10:
            return "multiplicationBy10"
        case .multiplicationBy2:
            return "multiplicationBy2"
        case .multiplicationBy3:
            return "multiplicationBy3"
        case .multiplicationBy4:
            return "multiplicationBy4"
        case .multiplicationBy5:
            return "multiplicationBy5"
        case .multiplicationBy6:
            return "multiplicationBy6"
        case .multiplicationBy7:
            return "multiplicationBy7"
        case .multiplicationBy8:
            return "multiplicationBy8"
        case .multiplicationBy9:
            return "multiplicationBy9"
        case .permutation:
            return "permutation"
        case .training:
            return "training"
        }
    }
}

enum StageMode: Int {
    case simple
    case exam
}
