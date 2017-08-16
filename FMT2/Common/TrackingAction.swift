import Foundation

enum TrackingAction {
    // Application
    case applicationInForeground(skippedNotifications: Int)
    case applicationInBackground
    case notificationClick(skippedNotification: Int)
    // Game
    case startNewGame
    // Introduction
    case introductionStart
    case introductionExit
    case introductionContinue
    case introductionRestart
    case introductionUserRestart
    case introductionFinish
    case introductionMistake(digit: Int)
    case introductionRightAnswer(digit: Int)
    case introductionColor(digit: Int, color: Color)
    case introductionExamStart
    case introductionExamFinish
    case introductionExamMistake(digit: Int)
    case introductionExamRightAnswer(digit: Int)
    // Other levels
    case levelStart(level: String)
    case levelExit(level: String)
    case levelResume(level: String)
    case levelRestart(level: String)
    case levelUserRestart(level: String)
    case levelFinish(level: String)
    case levelDigitMistake(level: String, firstDigit: Int, secondDigit: Int, digit: Int)
    case levelDigitRightAnswer(level: String, firstDigit: Int, secondDigit: Int, digit: Int)
    case levelExerciseMistake(level: String, firstDigit: Int, secondDigit: Int)
    case levelExerciseRightAnswer(level: String, firstDigit: Int, secondDigit: Int)
    case levelExamStart(level: String)
    case levelExamFinish(level: String)
    case levelExamMistake(level: String, firstDigit: Int, secondDigit: Int)
    case levelExamRightAnswer(level: String, firstDigit: Int, secondDigit: Int)
    // Training
    case trainStart
    case trainExerciseExit
    case trainExerciseResume
    case trainDigitMistake(firstDigit: Int, secondDigit: Int, digit: Int)
    case trainDigitRightAnswer(firstDigit: Int, secondDigit: Int, digit: Int)
    case trainExerciseMistake(firstDigit: Int, secondDigit: Int)
    case trainExerciseRightAnswer(firstDigit: Int, secondDigit: Int)
    
    var name: String {
        switch self {
        // Application
        case .applicationInForeground(let skippedNotifications):
            break
        case .applicationInBackground:
            break
        case .notificationClick(let skippedNotification):
            break
        // Game
        case .startNewGame:
            break
        // Introduction
        case .introductionStart:
            break
        case .introductionExit:
            break
        case .introductionContinue:
            break
        case .introductionRestart:
            break
        case .introductionUserRestart:
            break
        case .introductionFinish:
            break
        case .introductionMistake(let digit):
            break
        case .introductionRightAnswer(let digit):
            break
        case .introductionColor(let digit, let color):
            break
        case .introductionExamStart:
            break
        case .introductionExamFinish:
            break
        case .introductionExamMistake(let digit):
            break
        case .introductionExamRightAnswer(let digit):
            break
        // Other levels
        case .levelStart(let level):
            break
        case .levelExit(let level):
            break
        case .levelResume(let level):
            break
        case .levelRestart(let level):
            break
        case .levelUserRestart(let level):
            break
        case .levelFinish(let level):
            break
        case .levelDigitMistake(let level, let firstDigit, let secondDigit, let digit):
            break
        case .levelDigitRightAnswer(let level, let firstDigit, let secondDigit, let digit):
            break
        case .levelExerciseMistake(let level, let firstDigit, let secondDigit):
            break
        case .levelExerciseRightAnswer(let level, let firstDigit, let secondDigit):
            break
        case .levelExamStart(let level):
            break
        case .levelExamFinish(let level):
            break
        case .levelExamMistake(let level, let firstDigit, let secondDigit):
            break
        case .levelExamRightAnswer(let level, let firstDigit, let secondDigit):
            break
        // Training
        case .trainStart:
            break
        case .trainExerciseExit:
            break
        case .trainExerciseResume:
            break
        case .trainDigitMistake(let firstDigit, let secondDigit, let digit):
            break
        case .trainDigitRightAnswer(let firstDigit, let secondDigit, let digit):
            break
        case .trainExerciseMistake(let firstDigit, let secondDigit):
            break
        case .trainExerciseRightAnswer(let firstDigit, let secondDigit):
            break
        }
    }
}
