import UIKit

enum MenuButtonColor {
    case green
    case orange
}

extension MenuButtonColor {

    static let greenShadowColor = UIColor.init(red: 31/255, green: 134/255, blue: 46/255, alpha: 1.0)

    static let orangeShadowColor = UIColor.init(red: 149/255, green: 125/255, blue: 27/255, alpha: 1.0)

    var bodyImage: UIImage {
        switch self {
        case .green:
            return #imageLiteral(resourceName: "GreenButton")
        case .orange:
            return #imageLiteral(resourceName: "OrangeButton")
        }
    }
}
