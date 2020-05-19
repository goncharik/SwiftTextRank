import Foundation

extension String {
    public var dominantLanguage: String {
        if #available(iOS 11.0, OSX 10.13, watchOS 4.0, tvOS 11.0, *) {
            guard let languageCode = NSLinguisticTagger.dominantLanguage(for: self) else {
                return "en"
            }
            return languageCode
        } else {
            // Fallback to English on earlier versions
            return "en"
        }
    }

    public var words: [String] {
        return lowercased()
            .components(separatedBy: CharacterSet.letters.inverted)
    }

    ///Note: this method has low performance so it's better to execute it async
    public var sentences: [String] {
        var sentences = [String]()
        let range = self.range(of: self)

        self.enumerateSubstrings(in: range!, options: .bySentences) { (substring, _, _, _) in
            if let substring = substring,
                substring.isEmpty == false {
                sentences.append(substring)
            }
        }
        return sentences
    }

    ///Note: this method has low performance so it's better to execute it async
    public func stemmingWords() -> [String] {
        var stems: [String] = []

        let language = self.dominantLanguage
        let range = NSRange(location: 0, length: self.count)
        let tagOptions: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        let tagSchemes = NSLinguisticTagger.availableTagSchemes(forLanguage: language)
        let tagger = NSLinguisticTagger(tagSchemes: tagSchemes, options: Int(tagOptions.rawValue))

        tagger.string = self
        tagger.enumerateTags(in: range,
                             scheme: .lemma,
                             options: tagOptions) { (_, tokenRange, _, _) in
            let token = (self as NSString).substring(with: tokenRange)
            if !token.isEmpty {
                stems.append(token.lowercased())
            }
        }

        return stems
    }
}
