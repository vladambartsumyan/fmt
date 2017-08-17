import UIKit

class GAManager {   
    static func track(screen: TrackingScreen) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screen.name)
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    static func track(action: TrackingAction, with category: TrackingActionCategory) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: category.rawValue, action: action.info.action, label: action.info.label, value: nil).build() as [NSObject : AnyObject])
    }
}
