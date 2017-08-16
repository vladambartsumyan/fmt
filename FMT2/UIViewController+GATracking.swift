import UIKit

extension UIViewController {   
    func trackScreen(screen: TrackingScreen) {
        print(GAI.sharedInstance().defaultTracker == nil)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screen.name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
