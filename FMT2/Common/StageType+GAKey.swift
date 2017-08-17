import Foundation

extension StageType {
    var GAKey: String {
        switch self {
        case .introduction:       return "meet"
        case .multiplicationBy0:  return "0"
        case .multiplicationBy1:  return "1"
        case .multiplicationBy10: return "10"
        case .multiplicationBy2:  return "2"
        case .multiplicationBy3:  return "3"
        case .multiplicationBy4:  return "4"
        case .multiplicationBy5:  return "5"
        case .multiplicationBy6:  return "6"
        case .multiplicationBy7:  return "7"
        case .multiplicationBy8:  return "8"
        case .multiplicationBy9:  return "9"
        case .permutation:        return "perm"
        case .training:           return "train"
        }
    }
}
