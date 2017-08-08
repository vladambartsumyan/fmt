import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var serverTaskManager = ServerTaskManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKey.timeMark.rawValue)
        
        SoundHelper.prepareButtonSounds()

        registerLocalNotification(application: application)
        firstLaunch()
        setStartScreen()
        
        SoundHelper.shared.playBackgroundMusic()
        
        return true
    }
    
    func sendUsingTime() {
        let timeMark = UserDefaults.standard.value(forKey: UserDefaultsKey.timeMark.rawValue) as! Date
        ServerTaskManager.pushBack(.timeForDay(dateTimeStart: timeMark, dateTimeStop: Date()))
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SoundHelper.shared.pauseBackgroundMusic()
        SoundHelper.shared.stopVoice()
        sendUsingTime()
        resetNotification()
        if let rootVC = window?.rootViewController {
            if rootVC.needsToTimeAccumulation {
                if let rootGameVC = rootVC as? IsGameVC {
                    rootGameVC.globalStagePassing.updateElapsedTime()
                }
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        SoundHelper.shared.resumeBackgroundMusic()
        serverTaskManager.setNeedsLoading(true)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKey.timeMark.rawValue)
        if let rootVC = window?.rootViewController {
            if rootVC.needsToTimeAccumulation {
                if let rootGameVC = rootVC as? IsGameVC {
                    rootGameVC.globalStagePassing.addElapsedTime()
                }
            }
        }
    }

    func setStartScreen() {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = StartScreenVC(nibName: "StartScreenVC", bundle: nil)
        self.window?.makeKeyAndVisible()
    }

    func firstLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: UserDefaultsKey.launchedBefore.rawValue)
        if !launchedBefore {
            setUserDefaults()
            ServerTaskManager.pushBack(.registerDevice())
        }
    }

    func setUserDefaults() {
        Game.current.initOnDevice()
        UserDefaults.standard.set(Date().timeIntervalSince1970.hashValue, forKey: UserDefaultsKey.dateHashed.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.soundOn.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.launchedBefore.rawValue)
    }

    func registerLocalNotification(application: UIApplication) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_ in})
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }

    func setRootVCWithAnimation(_ viewController: UIViewController, animation: UIViewAnimationOptions) {
        let prevVC = self.window?.rootViewController
        UIView.transition(with: window!, duration: 0.5, options: animation, animations: {
            self.window?.rootViewController = viewController
        }, completion: { completed in
            for subview in self.window!.subviews {
                if subview.isKind(of: NSClassFromString("UITransitionView")!) {
                    subview.removeFromSuperview()
                }
            }
            prevVC?.dismiss(animated: false, completion: {
                prevVC?.view.removeFromSuperview()
            })
        })
    }

    func setRootVC(_ viewController: UIViewController) {
        let prevVC = self.window?.rootViewController
        self.window?.rootViewController = viewController
        for subview in self.window!.subviews {
            if subview.isKind(of: NSClassFromString("UITransitionView")!) {
                subview.removeFromSuperview()
            }
        }       
        prevVC?.dismiss(animated: false, completion: {
            prevVC?.view.removeFromSuperview()
        })
    }

    func resetNotification() {
        if #available(iOS 10, *) {
            // Cancel all notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()

            // Content
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("Notification.message", comment: "") 
            content.body = NSLocalizedString("Notification.action", comment: "")
            content.sound = UNNotificationSound.default()

            // Time-trigger
            let matchingComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date().addingTimeInterval(-1))
            let trigger = UNCalendarNotificationTrigger(dateMatching: matchingComponents, repeats: true)
            
            // Request
            let identifier = "DailyNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            // Registration
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            // Cancell all notifications
            UIApplication.shared.cancelAllLocalNotifications()

            // Content
            let notification = UILocalNotification()
            notification.alertBody = NSLocalizedString("Notification.message", comment: "")
            notification.alertAction = NSLocalizedString("Notification.action", comment: "")
            notification.soundName = UILocalNotificationDefaultSoundName

            // Time-trigger
            notification.fireDate = Date(timeIntervalSinceNow: 86400)
            notification.repeatInterval = .day

            // Registration
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }

}
