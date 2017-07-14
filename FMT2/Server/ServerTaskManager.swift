import Foundation
import RealmSwift
import Moya

class ServerTaskManager {

    private var provider = MoyaProvider<ServerTask>()
    
    private var needsLoading: Bool = true

    private var inWork: Bool = true
    
    func setNeedsLoading(_ needs: Bool) {
        needsLoading = needs
        if needsLoading && !inWork {
            sendNext()
        }
    }
    
    private static var serverTasks: Results<ServerTask>!
    private static var notificationToken: NotificationToken!
    
    static func pushBack(_ serverTask: ServerTask) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(serverTask)
            for parameter in serverTask.parameterList {
                realm.add(parameter)
            }
        }
    }

    private static func dropFront() {
        let realm = try! Realm()
        guard let serverTask = ServerTaskManager.serverTasks.first else {
            return
        }
        try! realm.write {
            for parameter in serverTask.parameterList {
                realm.delete(parameter)
            }
            realm.delete(serverTask)
        }
    }

    private static func front() -> ServerTask? {
        return ServerTaskManager.serverTasks.first
    }
    
    init() {
        let realm = try! Realm()
        ServerTaskManager.serverTasks = realm.objects(ServerTask.self).sorted(byKeyPath: "createdAt")
        ServerTaskManager.notificationToken = ServerTaskManager.serverTasks.addNotificationBlock { changes in
            switch changes {
            case .update(_, let deletions, let insertions, _):
                if ServerTaskManager.serverTasks.count + deletions.count - insertions.count == 0 {
                    self.sendNext()
                }
                break
            case .initial:
                self.sendNext()
                break
            default:
                break
            }
        }
    }

    private func sendNext() {
        guard let serverTask = ServerTaskManager.front(), needsLoading else {
            inWork = false
            return
        }
        inWork = true
        provider.request(serverTask) { result in
            switch result {
            case .success(let response):
                self.log(response)
                guard 200 <= response.statusCode && response.statusCode < 300 else {
                    self.resendIfNeeded()
                    return
                }
                ServerTaskManager.dropFront()
                self.sendNext()
                break
            case .failure(_):
                self.resendIfNeeded()
                break
            }
        }
    }
    
    func resendIfNeeded() {
        if UIApplication.shared.applicationState != .background {
            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: self.sendNext)
        } else {
            inWork = false
        }
    }
    
    func log(_ response: Response) {
        print("\nRequset: >>>>>>>>>>>>>>>>>>")
        print(response.request!)
        print(response.request!.allHTTPHeaderFields ?? "HEADERS EMPTY")
        print("Method:")
        print(response.request! .httpMethod!)
        print("Body: ")
        let body = String.init(data: response.request!.httpBody!, encoding: String.Encoding.utf8)!
        print(body)
        print("\nResponse: <<<<<<<<<<<<<<<<<")
        do {
            print(try response.mapString())
            print(response.statusCode)
        } catch {
            print("FAIL")
        }
    }
    
}
