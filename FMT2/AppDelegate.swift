import UIKit
import RealmSwift
import UserNotifications
import MyTrackerSDK
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var serverTaskManager = ServerTaskManager()
    
    var action: TrackingAction!
    var fullDaysInBackground: Int? = nil
    var timer: Timer? = nil
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        registerGoogleAnalytics()
        registerMyTracker()
        registerFirebase()
        
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
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKey.backgroundDate.rawValue)
        GAManager.track(action: .applicationInBackground, with: .application)
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
        cancelAllNotifications()
        sendNumberOfSkippedNotificationWithTimer()
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
    
    func sendNumberOfSkippedNotificationWithTimer() {        
        guard let inBackgroundStartDate = UserDefaults.standard.value(forKey: UserDefaultsKey.backgroundDate.rawValue) as? Date else {
            return
        }
        let curDate = Date()
        let timeIntervalInBackground = curDate.timeIntervalSince(inBackgroundStartDate)
        fullDaysInBackground = Int(timeIntervalInBackground / 86400)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(sendApplicationInForeground), userInfo: nil, repeats: false)
    }
    
    @objc func sendApplicationInForeground() {
        guard let fullDaysInBackgroundUnwrapped = fullDaysInBackground else {
            return
        }
        fullDaysInBackground = nil
        GAManager.track(action: .applicationInForeground(skippedNotifications: fullDaysInBackgroundUnwrapped), with: .application)
        print("applicationIn \(fullDaysInBackgroundUnwrapped)")
    }
    
    func sendPushClick() {
        timer?.invalidate()
        guard let fullDaysInBackgroundUnwrapped = fullDaysInBackground else {
            return
        }
        fullDaysInBackground = nil
        let numberOfSkippedNotification = fullDaysInBackgroundUnwrapped - 1
        GAManager.track(action: .notificationClick(skippedNotifications: numberOfSkippedNotification), with: .application)
        print("pushClick \(numberOfSkippedNotification)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        sendPushClick()
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
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.voiceOn.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.launchedBefore.rawValue)
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isFullVersion.rawValue)
    }

    func registerLocalNotification(application: UIApplication) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_,_  in})
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

    func registerGoogleAnalytics() {
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return
        }
        gai.trackUncaughtExceptions = true
        gai.defaultTracker = gai.tracker(withTrackingId: "UA-108274588-1")
//        gai.logger.logLevel = .verbose
    }
    
    func registerMyTracker() {
        MRMyTracker.createTracker("57895877048205058238")
        MRMyTracker.setupTracker()
    }
    
    func registerFirebase() {
        FIRApp.configure()
    }
    
    func cancelAllNotifications() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    func resetNotification() {
        // Cancell all notifications
        cancelAllNotifications()
        if #available(iOS 10, *) {
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
