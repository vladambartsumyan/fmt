import UIKit

class MenuItem {
    var buttonColor: ButtonColor!
    var title: String!
    var iconName: String!
    var action: (() -> ())!

    init(buttonColor: ButtonColor, title: String, iconName: String, action: @escaping (()) -> ()) {
        self.buttonColor = buttonColor
        self.title = title
        self.iconName = iconName
        self.action = action
    }
}
