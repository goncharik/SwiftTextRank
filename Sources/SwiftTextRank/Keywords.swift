import Foundation

public final class Keywords {
    private let words: [String]
    private let ngram: Int = 3
    private let textRank = TextRank<String>()

    public init(_ text: String) {
        let lang = text.dominantLanguage
        let stopwords = Stopwords.language(lang)
        self.words = text.words
            .filter { $0.count > 2 }
            .filter { stopwords.contains($0) == false }
    }

    public func build() -> [String] {
        for (index, node) in words.enumerated() {
            var (min, max) = (index - ngram, index + ngram)
            if min < 0 {
                min = words.startIndex
            }
            if max > words.count {
                max = words.endIndex
            }
            words[min..<max].forEach { word in
                textRank.add(edge: node, to: word)
            }
        }

        return textRank.build()
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }
}
