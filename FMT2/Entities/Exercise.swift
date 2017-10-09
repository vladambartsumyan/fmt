import Foundation
import RealmSwift

class Exercise: Object {
    @objc dynamic var firstDigit: Int = -1
    @objc dynamic var secondDigit: Int = -1
    @objc dynamic private var _type: Int = 0
    
    var type: StageType {
        get { return StageType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    static func create(_ firstDigit: Int, _ secondDigit: Int = -1) -> Exercise {
        let exercise = Exercise()
        exercise.firstDigit = firstDigit
        exercise.secondDigit = secondDigit
        let (min, max) = firstDigit < secondDigit ? (firstDigit, secondDigit) : (secondDigit, firstDigit)
        if max == 10 {
            exercise.type = .multiplicationBy10
            return exercise
        }
        if firstDigit > secondDigit && ![-1, 0, 1].contains(secondDigit) {
            exercise.type = .permutation
            return exercise
        }
        switch min {
        case -1:
            exercise.type = .introduction
            break
        case 0:
            exercise.type = .multiplicationBy0
            break
        case 1:
            exercise.type = .multiplicationBy1
            break
        case 2:
            exercise.type = .multiplicationBy2
            break
        case 3:
            exercise.type = .multiplicationBy3
            break
        case 4:
            exercise.type = .multiplicationBy4
            break
        case 5:
            exercise.type = .multiplicationBy5
            break
        case 6:
            exercise.type = .multiplicationBy6
            break
        case 7:
            exercise.type = .multiplicationBy7
            break
        case 8:
            exercise.type = .multiplicationBy8
            break
        case 9:
            exercise.type = .multiplicationBy9
            break
        default:
            break
        }
        return exercise
    }
    
    func createExercisePassing() -> ExercisePassing {
        let exercisePassing = ExercisePassing()
        exercisePassing.exercise = self
        return exercisePassing
    }
    
    var allVariants: ([Int], required: Int) {
        let (min, max) = firstDigit < secondDigit ? (firstDigit, secondDigit) : (secondDigit, firstDigit)
        if max == 10 {
            return ((1...8).map{$0 * 10}.filter{$0 != max * min}, required: max + min)
        }
        switch min {
        case 0: return ((1...9).filter{$0 != max}, required: max)
        case 1: return ((2...9).filter{![max + 1, max].contains($0)}, required: max + min)
        case 2:
            switch max {
            case 2: return ([2, 5, 6, 7, 8], required: 3)
            case 3: return ([2, 3, 4, 7, 8], required: 5)
            case 4: return ([3, 4, 5, 7, 10], required: 6)
            case 5: return ([4, 5, 6, 8, 9], required: 7)
            case 6: return ([5, 6, 7, 9, 10], required: 8)
            case 7: return ([6, 7, 8, 10, 12], required: 9)
            case 8: return ([7, 8, 9, 12, 14], required: 10)
            case 9: return ([8, 9, 10, 14, 16], required: 11)
            default: return ([], 0)
            }
        case 3:
            switch max {
            case 3: return ([7, 8, 10, 12, 14], required: 6)
            case 4: return ([6, 8, 9, 10, 14], required: 7)
            case 5: return ([10, 12, 14, 16, 18], required: 8)
            case 6: return ([10, 12, 14, 15, 16], required: 9)
            case 7: return ([14, 15, 16, 18, 20], required: 10)
            case 8: return ([14, 15, 16, 18, 21], required: 11)
            case 9: return ([15, 16, 20, 21, 24], required: 12)
            default: return ([], required: 0)
            }
        case 4:
            switch max {
            case 4: return ([7, 9, 10, 12, 15], required: 8)
            case 5: return ([15, 16, 18, 21, 27], required: 9)
            case 6: return ([16, 18, 20, 21, 28], required: 10)
            case 7: return ([16, 20, 21, 24, 27], required: 11)
            case 8: return ([20, 21, 24, 27, 28], required: 12)
            case 9: return ([15, 18, 27, 28, 32], required: 13)
            default: return ([], required: 0)
            }
        case 5:
            switch max {
            case 5: return ([15, 18, 20, 21, 24], required: 10)
            case 6: return ([15, 25, 27, 20, 32], required: 11)
            case 7: return ([15, 20, 25, 28, 30], required: 12)
            case 8: return ([15, 18, 20, 25, 35], required: 13)
            case 9: return ([15, 16, 25, 35, 40], required: 14)
            default: return ([], required: 0)
            }
        case 6:
            switch max {
            case 6: return ([24, 27, 28, 30, 32], required: 12)
            case 7: return ([27, 28, 35, 36, 40], required: 13)
            case 8: return ([28, 32, 36, 42, 45], required: 14)
            case 9: return ([18, 36, 40, 42, 48], required: 15)
            default: return ([], required: 0)
            }
        case 7:
            switch max {
            case 7: return ([35, 36, 42, 48, 54], required: 14)
            case 8: return ([40, 42, 48, 49, 54], required: 15)
            case 9: return ([36, 45, 48, 54, 56], required: 16)
            default: return ([], required: 0)
            }
        case 8:
            switch max {
            case 8: return ([48, 50, 54, 56, 63], required: 16)
            case 9: return ([36, 48, 56, 64, 80], required: 17)
            default: return ([], required: 0)
            }
        case 9: return ([54, 56, 63, 72, 90], required: 18)
        default: return ([], required: 0)
        }
    }
}
