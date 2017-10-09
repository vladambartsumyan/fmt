import Foundation

extension Array {
    func randomElem() -> Element? {
        guard self.count != 0 else {
            return nil
        }
        return self[Int.random(min: 0, max: self.count - 1)]
    }
    
    mutating func eraseRandomElem() -> Element? {
        guard self.count != 0 else {
            return nil
        }
        let index = Int.random(min: 0, max: self.count - 1)
        let elem = self[index]
        self.remove(at: index)
        return elem
    }
}

extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
