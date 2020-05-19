import Foundation

extension Array {
    private func addCombination(previous: [Element], pivotal: [Element]) -> [([Element], [Element])] {
        var pivotal = pivotal
        return (0..<pivotal.count)
            .map { _ -> ([Element], [Element]) in
                (previous + [pivotal.remove(at: 0)], pivotal)
            }
    }

    func combinations(_ length: Int) -> [[Element]] {
        [Int](1...length)
            .reduce([([Element](), self)]) { (accum, _) in
                accum.flatMap(addCombination)
            }
            .map { $0.0 }
    }
}
