import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        firstLaunch()
        
        setStartScreen()
        
        return true
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func setStartScreen() {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = StartScreenVC(nibName: "StartScreenVC", bundle: nil)
        self.window?.makeKeyAndVisible()
    }
    
    func firstLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: UserDefaultsKey.launchedBefore.rawValue)
        if !launchedBefore  {
            Game.current.initOnDevice()
            UserDefaults.standard.set(Date().timeIntervalSince1970.hashValue, forKey: UserDefaultsKey.dateHashed.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.soundOn.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.launchedBefore.rawValue)
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

}

