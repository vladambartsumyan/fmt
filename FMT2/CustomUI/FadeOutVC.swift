import UIKit

class FadeInOutVC: UIViewController {

    var needsFadeIn: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewsForAnimate = getFadeInArray()
        if (needsFadeIn) {
            for viewArray in viewsForAnimate {
                for view in viewArray {
                    view.alpha = 0.0
                    view.isHidden = true
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let viewsForAnimate = getFadeInArray()
        if (needsFadeIn) {
            for viewArray in viewsForAnimate {
                for view in viewArray {
                    view.isHidden = false
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fadeIn(_ handler: ((()) -> ())? = nil) {
        let viewsForAnimate = getFadeInArray()
        var delay: TimeInterval = 0.2
        for ind in 0..<viewsForAnimate.count {
            UIView.animate(withDuration: 0.5, delay: delay, animations: {
                for view in viewsForAnimate[ind] {
                    view.alpha = 1.0
                }
            }) { _ in
                if ind == 0 {
                    handler?()
                }
            }
            delay += 0.2
        }
        if viewsForAnimate.count == 0 {
            handler?()
        }
    }

    func fadeOut(_ handler: ((()) -> ())?) {
        fadeOut(array: getFadeOutArray(), handler)
    }
    
    func fadeOut(array: [[UIView]], _ handler: ((()) -> ())?) {
        var delay: TimeInterval = 0
        for ind in stride(from: array.count - 1, to: -1, by: -1) {
            UIView.animate(withDuration: 0.2, delay: delay, animations: {
                for view in array[ind] {
                    view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                }
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.2, animations: {
                    for view in array[ind] {
                        view.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
                        view.alpha = 0.0
                    }
                }) { completed in
                    if ind == 0 {
                        handler?()
                    }
                }
            })
            delay += 0.2
        }
        if array.count == 0 {
            handler?()
        }
    }
    
    func getFadeInArray() -> [[UIView]] {
        return []
    }
    
    func getFadeOutArray() -> [[UIView]] {
        return []
    }
    
    func fadeInView(_ view: UIView) {
        view.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1.0
        }
    }

}
