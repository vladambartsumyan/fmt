import UIKit

extension ServerTask {

    static func registerDevice() -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .registerDevice
        serverTask.createdAt = Date()
        let parameters:[String : String] = [:]
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func setColorForDigit(color: Color, digit: Int) -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .setColorForDigit
        serverTask.createdAt = Date()
        var parameters: [String : String] = [:]
        parameters["color"] = color.rawValue
        parameters["numeral"] = "\(digit)"
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func introductionStatistic(countError: Int, digit: Int) -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .introductionStatistic
        serverTask.createdAt = Date()
        var parameters:[String : String] = [:]
        parameters["count_error"] = "\(countError)"
        parameters["numeral"] = "\(digit)"
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func exerciseStatistic(countError: Int, firstDigit: Int, secondDigit: Int, time: Double) -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .exerciseStatistic
        serverTask.createdAt = Date()
        var parameters:[String : String] = [:]
        parameters["count_error"] = "\(countError)"
        parameters["first_numeral"] = "\(firstDigit)"
        parameters["second_numeral"] = "\(secondDigit)"
        parameters["time"] = time.toTimeStringHMS
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func bonusStatistic(countError: Int, firstDigit: Int, secondDigit: Int, time: Double) -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .bonusStatistic
        serverTask.createdAt = Date()
        var parameters:[String : String] = [:]
        parameters["count_error"] = "\(countError)"
        parameters["first_numeral"] = "\(firstDigit)"
        parameters["second_numeral"] = "\(secondDigit)"
        parameters["time"] = time.toTimeStringHMS
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func timeForDay(dateTimeStart: Date, dateTimeStop: Date) -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .timeForDay
        serverTask.createdAt = Date()
        var parameters:[String : String] = [:]
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        parameters["date_time_start"] = dateFormatter.string(from: dateTimeStart)
        parameters["date_time_stop"] = dateFormatter.string(from: dateTimeStop)
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func introductionFinished() -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .introductionFinished
        serverTask.createdAt = Date()
        let parameters:[String : String] = [:]
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func exerciseFinished() -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .exerciseFinished
        serverTask.createdAt = Date()
        let parameters:[String : String] = [:]
        serverTask.setParameters(parameters)
        return serverTask
    }

    static func startGame() -> ServerTask {
        let serverTask = ServerTask()
        serverTask.serverTaskType = .startGame
        serverTask.createdAt = Date()
        let parameters:[String : String] = [:]
        serverTask.setParameters(parameters)
        return serverTask
    }
}
