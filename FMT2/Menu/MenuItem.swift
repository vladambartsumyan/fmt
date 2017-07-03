import UIKit

class MenuItem {
    var buttonColor: MenuButtonColor!
    var title: String!
    var iconName: String!
    var action: (() -> ())!

    init(buttonColor: MenuButtonColor, title: String, iconName: String, action: @escaping (()) -> ()) {
        self.buttonColor = buttonColor
        self.title = title
        self.iconName = iconName
        self.action = action
    }
}
