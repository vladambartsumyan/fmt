import Foundation
import RealmSwift
import Moya

class Parameter: Object {
    dynamic var key: String = ""
    dynamic var value: String = ""
}

class ServerTask: Object, TargetType {
    dynamic var type: Int = 0
    dynamic var createdAt: Date = Date()
    var parameterList = List<Parameter>()

    var serverTaskType: ServerTaskType {
        get {
            return ServerTaskType(rawValue: type)!
        }
        set {
            type = newValue.rawValue
        }
    }

    var parameters: [String : Any]? {
        var result: [String : String] = ["api_key" : ServerTask.apiKey, "device" : "\(UIDevice.current.identifierForVendor!)" + String(UserDefaults.standard.integer(forKey: UserDefaultsKey.dateHashed.rawValue))  ]
        for parameter in parameterList {
            result[parameter.key] = parameter.value
        }
        return result
    }
    
    func setParameters(_ parameters: [String : String]) {
        parameterList = List<Parameter>.init()
        for parameterPair in parameters {
            let parameter = Parameter()
            parameter.key = parameterPair.key
            parameter.value = parameterPair.value
            parameterList.append(parameter)
        }
    }

//    public var baseURL: URL { return URL(string: "https://api.multiplication.dev.leko.team/api")! }
    public var baseURL: URL { return URL(string: "http://127.0.0.1:8000")! }

    static let apiKey = "56vBS1O2wUT5F520"

    public var path: String {
        return version + pathWithoutVersion
    }

    private var pathWithoutVersion: String {
        switch serverTaskType {
        case .registerDevice:
            return "/users"
        case .setColorForDigit:
            return "/numeral_users"
        case .introductionStatistic:
            return "/cognition_statistics"
        case .exerciseStatistic:
            return "/game_statistics"
        case .bonusStatistic:
            return "/training_statistics"
        case .timeForDay:
            return "/working_time_statistics"
        case .introductionFinished:
            return "/cognition_status_completeds"
        case .exerciseFinished:
            return "/game_status_completeds"
        case .startGame:
            return "/resets"
        }
    }

    private var version: String {
        return "/v1"
    }

    public var method: Moya.Method {
        switch serverTaskType {
        case .setColorForDigit, .introductionFinished, .exerciseFinished, .startGame:
            return .put
        default:
            return .post
        }
    }

    var parameterEncoding: ParameterEncoding {
        return CustomEncoding()
    }

    public var task: Task {
        return .request
    }

    public var sampleData: Data {
        return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
