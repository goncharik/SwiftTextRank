import Foundation

public final class Summary {
    private let sentences: [Sentence]
    private let textRank = TextRank<Sentence>()

    public init(_ text: String) {
        self.sentences = text.sentences.map { Sentence($0) }
    }

    public func build() -> [String] {
        let combinations = self.sentences.combinations(2)
        combinations.forEach {
            guard let pivotal = $0.first,
                let node = $0.last else { return }
            add(edge: pivotal, node: node)
        }

        return textRank.build()
            .sorted { $0.1 > $1.1 }
            .map { $0.0.text }
    }

    private func add(edge pivotal: Sentence, node: Sentence) {
        let pivotalWordCount = Float(pivotal.words.count)
        let nodeWordCount = Float(node.words.count)

        // calculate weight by co-occurrence of words between sentences
        var score: Float = Float(pivotal.words.filter { node.words.contains($0) }.count)
        score = score / (log(pivotalWordCount) + log(nodeWordCount))

        textRank.add(edge: pivotal, to: node, weight: score)
        textRank.add(edge: node, to: pivotal, weight: score)
    }
}

// MARK: - Text helper

final class Sentence: Hashable {
    let text: String
    lazy var words: [String] = {
        let lang = text.dominantLanguage
        let stopwords = Stopwords.language(lang)
        return text.stemmingWords()
            .filter { stopwords.contains($0) == false }
    }()

    init(_ text: String) {
        self.text = text
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    static func == (lhs: Sentence, rhs: Sentence) -> Bool {
        return lhs.text == rhs.text
    }
}
