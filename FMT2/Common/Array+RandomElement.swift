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
