import Foundation

enum Stopwords {
    static func language(_ lang: String) -> [String] {
        switch lang {
        case "ru":
            return ru()
        default:
            return en()
        }
    }
}


