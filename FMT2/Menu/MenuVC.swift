import UIKit
import SVGKit

class MenuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var menu: UICollectionView!

    private var menuDataSource: [[MenuItem]]!

    private var spacing: [CGFloat]!

    private let menuCellReuseId = "menuCellReuseId"

    @IBOutlet weak var background: UIImageView!
    
    // LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = SVGKImage(named: "background").uiImage
        configureMenuDataSource()
        configureCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // CONFIGURES

    func configureCollectionView() {
        menu.register(MenuButtonCell.self, forCellWithReuseIdentifier: menuCellReuseId)
        menu.register(UINib.init(nibName: "MenuButtonCell", bundle: nil), forCellWithReuseIdentifier: menuCellReuseId)
    }

    func configureMenuDataSource() {
        let newGameTitle = NSLocalizedString("Menu.newGame", comment: "")
        let soundSwitchTitleKey = UserDefaults.standard.bool(forKey: UserDefaultsKey.soundOn.rawValue) ? "Menu.offSound" : "Menu.onSound"
        let soundSwitchTitle = NSLocalizedString(soundSwitchTitleKey, comment: "")
        let voiceSwitchTitleKey = UserDefaults.standard.bool(forKey: UserDefaultsKey.voiceOn.rawValue) ? "Menu.offVoice" : "Menu.onVoice"
        let voiceSwitchTitle = NSLocalizedString(voiceSwitchTitleKey, comment: "")
        let statisticTitle = NSLocalizedString("Menu.statistic", comment: "")
        let feedbackTitle = NSLocalizedString("Menu.feedback", comment: "")
        let continueTitle = NSLocalizedString("Menu.continue", comment: "")
        menuDataSource = [
                [
                        MenuItem(buttonColor: .green, title: continueTitle, iconName: "ContinueButton", action: self.continueGame),
                        MenuItem(buttonColor: .green, title: newGameTitle, iconName: "NewGameButton", action: self.startNewGame),
                        MenuItem(buttonColor: .green, title: soundSwitchTitle, iconName: "SongButton", action: self.switchSounds),
                        MenuItem(buttonColor: .green, title: voiceSwitchTitle, iconName: "VoiceButton", action: self.switchVoice)
                ],
                [
                        MenuItem(buttonColor: .orange, title: statisticTitle, iconName: "ParentLockButton", action: self.statistic),
                        MenuItem(buttonColor: .orange, title: feedbackTitle, iconName: "EmailButton", action: self.feedback)
                ]
        ]
    }

    // ACTIONS

    func startNewGame() {
        if Game.current.newGame {
            newGameTransition()
        } else {
            self.present(
                    AlertMaker.newGameAlert {
                        self.view.isUserInteractionEnabled = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: self.newGameTransition)
                    },
                    animated: true,
                    completion: nil
            )
        }
    }

    func newGameTransition() {
        Game.current.reset()
        let vc = TutorialVC(nibName: "TutorialVC", bundle: nil)
        AppDelegate.current.setRootVCWithAnimation(vc, animation: .transitionFlipFromRight)
    }

    func continueGame() {
        let vc = StageMapVC(nibName: "StageMapVC", bundle: nil)
        AppDelegate.current.setRootVCWithAnimation(vc, animation: .transitionFlipFromRight)
    }

    func switchSounds() {
        let key = UserDefaultsKey.soundOn.rawValue
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
        UserDefaults.standard.bool(forKey: key) ? SoundHelper.shared.resumeBackgroundMusic() : SoundHelper.shared.pauseBackgroundMusic()
        configureMenuDataSource()
        menu.reloadData()
    }
    
    func switchVoice() {
        let key = UserDefaultsKey.voiceOn.rawValue
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
        if !UserDefaults.standard.bool(forKey: key) {
            SoundHelper.shared.stopVoice()
        }
        configureMenuDataSource()
        menu.reloadData()
    }

    func statistic() {
        let vc = GeneralStatisticVC(nibName: "GeneralStatisticVC", bundle: nil)
        AppDelegate.current.setRootVCWithAnimation(vc, animation: .transitionFlipFromRight)
    }

    func feedback() {
        openMailApp()
    }

    func openMailApp() {

        let toEmail = "test@leko.in"
        let subject = "[Веселая таблица умножения] Обратная связь.".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

        let version = "version: \(versionNumber)"

        let vendorID = UIDevice.current.identifierForVendor!
        let startDate = UserDefaults.standard.integer(forKey: "dateHash")
        let device = "device: \(vendorID)\(startDate)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "ru")
        let curDate = "date: " + dateFormatter.string(from: Date())

        let message = "Напишите нам ваши пожелания или расскажите о проблеме – нам это очень важно. Спасибо!"

        let newStringLiteral = "\n"

        let spacing = newStringLiteral + newStringLiteral

        let body = [message, spacing, version, device, curDate]
                .joined(separator: newStringLiteral)
                .appending("\n\n\n")
                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let urlString = "mailto:\(toEmail)?subject=\(subject)&body=\(body)"
        if let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
    }

    // COLLECTION VIEW

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menu.dequeueReusableCell(withReuseIdentifier: menuCellReuseId, for: indexPath) as! MenuButtonCell
        let menuItem = menuDataSource[indexPath.section][indexPath.row]
        cell.menuButton.setBodyColor(bodyColor: menuItem.buttonColor)
        cell.menuButton.setTitle(titleText: menuItem.title)
        cell.menuButton.setIcon(withName: menuItem.iconName)
        cell.action = menuItem.action
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuDataSource[section].count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return menuDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: menu.bounds.width, height: 65 / 670 * menu.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: menu.bounds.width, height: section == 0 ? 100 / 670 * menu.bounds.height : 67 / 670 * menu.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18 / 670 * menu.bounds.height
    }
}
