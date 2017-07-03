import UIKit

class MenuButtonCell: UICollectionViewCell {

    @IBOutlet weak var menuButton: MenuButton!

    var action: (() -> ())!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func touchUpInside(_ sender: MenuButton) {
        self.action()
    }

}
