import Foundation

enum TrackingActionCategory: String {
    case application
    case game
}

enum TrackingAction {
    // Application
    case applicationInForeground(skippedNotifications: Int)
    case applicationInBackground
    case notificationClick(skippedNotifications: Int)
    // Game
    case startNewGame
    // Introduction
    case introductionMistake(digit: Int)
    case introductionRightAnswer(digit: Int)
    case introductionColor(digit: Int, color: Color)
    case introductionExamMistake(digit: Int)
    case introductionExamRightAnswer(digit: Int)
    // Other levels
    case levelStart(level: StageType)
    case levelExit(level: StageType)
    case levelContinue(level: StageType)
    case levelRestart(level: StageType)
    case levelUserRestart(level: StageType)
    case levelFinished(level: StageType)
    case levelDigitMistake(level: StageType, firstDigit: Int, secondDigit: Int, digit: Int)
    case levelDigitRightAnswer(level: StageType, firstDigit: Int, secondDigit: Int, digit: Int)
    case levelExerciseMistake(level: StageType, firstDigit: Int, secondDigit: Int)
    case levelExerciseRightAnswer(level: StageType, firstDigit: Int, secondDigit: Int)
    case levelExamStart(level: StageType)
    case levelExamFinished(level: StageType)
    case levelExamDigitMistake(level: StageType, firstDigit: Int, secondDigit: Int, digit: Int)
    case levelExamDigitRightAnswer(level: StageType, firstDigit: Int, secondDigit: Int, digit: Int)
    case levelExamExerciseMistake(level: StageType, firstDigit: Int, secondDigit: Int)
    case levelExamExerciseRightAnswer(level: StageType, firstDigit: Int, secondDigit: Int)
    
    var info: (action: String, label: String?) {
        switch self {
        // Application
        case .applicationInForeground(let skippedNotifications):                                return ("application_in", "\(skippedNotifications)")
        case .applicationInBackground:                                                          return ("application_out", nil)
        case .notificationClick(let skippedNotification):                                       return ("push_click", "\(skippedNotification)")
        // Game
        case .startNewGame:                                                                     return ("start_new_game", nil)
        // Introduction
        case .introductionMistake(let digit):                                                   return ("meet_mistake", "\(digit)")
        case .introductionRightAnswer(let digit):                                               return ("meet_success", "\(digit)")
        case .introductionColor(let digit, let color):                                          return ("meet_color", "\(digit)_\(color.rawValue)")
        case .introductionExamMistake(let digit):                                               return ("meet_exam_mistake", "\(digit)")
        case .introductionExamRightAnswer(let digit):                                           return ("meet_exam_success", "\(digit)")
        // Other levels
        case .levelStart(let level):                                                            return ("\(level.GAKey)_start", nil)
        case .levelExit(let level):                                                             return ("\(level.GAKey)_exit", nil)
        case .levelContinue(let level):                                                         return ("\(level.GAKey)_continue", nil)
        case .levelRestart(let level):                                                          return ("\(level.GAKey)_restart", nil)
        case .levelUserRestart(let level):                                                      return ("\(level.GAKey)_user_restart", nil)
        case .levelFinished(let level):                                                         return ("\(level.GAKey)_finished", nil)
        case .levelDigitMistake(let level, let firstDigit, let secondDigit, let digit):         return ("\(level.GAKey)_mistake", "\(firstDigit)_\(secondDigit)_\(digit)")
        case .levelDigitRightAnswer(let level, let firstDigit, let secondDigit, let digit):     return ("\(level.GAKey)_success", "\(firstDigit)_\(secondDigit)_\(digit)")
        case .levelExerciseMistake(let level, let firstDigit, let secondDigit):                 return ("\(level.GAKey)_cases_mistake", "\(firstDigit)_\(secondDigit)")
        case .levelExerciseRightAnswer(let level, let firstDigit, let secondDigit):             return ("\(level.GAKey)_cases_success", "\(firstDigit)_\(secondDigit)")
        case .levelExamStart(let level):                                                        return ("\(level.GAKey)_exam_start", nil)
        case .levelExamFinished(let level):                                                     return ("\(level.GAKey)_exam_finished", nil)
        case .levelExamDigitMistake(let level, let firstDigit, let secondDigit, let digit):     return ("\(level.GAKey)_exam_mistake", "\(firstDigit)_\(secondDigit)_\(digit)")
        case .levelExamDigitRightAnswer(let level, let firstDigit, let secondDigit, let digit): return ("\(level.GAKey)_exam_success", "\(firstDigit)_\(secondDigit)_\(digit)")
        case .levelExamExerciseMistake(let level, let firstDigit, let secondDigit):             return ("\(level.GAKey)_exam_cases_mistake", "\(firstDigit)_\(secondDigit)")
        case .levelExamExerciseRightAnswer(let level, let firstDigit, let secondDigit):         return ("\(level.GAKey)_exam_cases_success", "\(firstDigit)_\(secondDigit)")
        }
    }
}
