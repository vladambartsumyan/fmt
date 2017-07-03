import Foundation

extension Double {

    var toTimeStringHMS: String {
        let h = Int.init(self / 3600)
        let m = Int.init((self - Double(h) * 3600) / 60)
        var doubleS = self - Double(h) * 3600 - Double(m) * 60
        doubleS.round()
        let s = Int.init(doubleS)
        return
            [h, m, s].map
                { t -> String in
                    let ts = String(t)
                    return ts.characters.count == 1 ? "0" + ts : ts
                }.joined(separator: ":")
    }
    
    var toTimeStringHM: String {
        var h = Int.init(self / 3600)
        var m = Int.init((self - Double(h) * 3600) / 60)
        var doubleS = self - Double(h) * 3600 - Double(m) * 60
        doubleS.round()
        let s = Int.init(doubleS)
        if s > 0 {
            m += 1
        }
        if m >= 60 {
            h += Int(m / 60)
            m = m % 60
        }
        return
            [h, m].map
                { t -> String in
                    let ts = String(t)
                    return ts.characters.count == 1 ? "0" + ts : ts
                }.joined(separator: ":")
    }
}
