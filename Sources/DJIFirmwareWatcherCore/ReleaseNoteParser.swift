import Foundation

public struct ReleaseNoteParser: Sendable {
    public init() {}

    public func releaseNotes(in html: String) -> [ReleaseNote] {
        let structured = structuredReleaseNotes(in: html)
        if !structured.isEmpty {
            return unique(structured)
        }
        return unique(anchorReleaseNotes(in: html))
    }

    public func newestReleaseNote(in html: String, for product: DJIProduct) -> ReleaseNote? {
        releaseNotes(in: html)
            .filter { note in
                let title = normalized(note.title)
                return product.matchingTerms.contains { title.contains(normalized($0)) }
            }
            .max { $0.date < $1.date }
    }

    private func structuredReleaseNotes(in html: String) -> [ReleaseNote] {
        let pattern = #"\{[^{}]{0,3000}\"release_at\":\"([^\"]+)\"[^{}]{0,3000}\"product_title\":\"([^\"]+)\"[^{}]{0,1000}\"manual_category\":\"([^\"]*[Rr]elease [Nn]otes[^\"]*)\"[^{}]{0,1000}\"version\":\"([^\"]*)\"[^{}]{0,1000}\"url\":\"([^\"]+)\"[^{}]*\}"#
        return matches(pattern: pattern, in: html).compactMap { groups in
            guard groups.count == 5,
                  let date = Self.dateFormatter.date(from: groups[0]),
                  let url = URL(string: decodeJSONString(groups[4]))
            else { return nil }

            let productTitle = decodeJSONString(groups[1]).trimmingCharacters(in: .whitespacesAndNewlines)
            let category = decodeJSONString(groups[2]).trimmingCharacters(in: .whitespacesAndNewlines)
            let version = decodeJSONString(groups[3]).trimmingCharacters(in: .whitespacesAndNewlines)
            let title = [productTitle, category, version]
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            return ReleaseNote(title: title, date: date, pdfURL: url)
        }
    }

    private func anchorReleaseNotes(in html: String) -> [ReleaseNote] {
        let pattern = #"(?is)<div[^>]*class=\"[^\"]*(?:document-name|groups-item-name)[^\"]*\"[^>]*>([^<]*[Rr]elease [Nn]otes[^<]*)</div>\s*<div[^>]*class=\"[^\"]*(?:document-time|groups-item-date)[^\"]*\"[^>]*>(\d{4}-\d{2}-\d{2})</div>.*?<a[^>]*href=\"([^\"]+)\""#
        return matches(pattern: pattern, in: html).compactMap { groups in
            guard groups.count == 3,
                  let date = Self.dateFormatter.date(from: stripTags(groups[1])),
                  let url = URL(string: decodeHTMLEntities(groups[2]))
            else { return nil }
            return ReleaseNote(
                title: decodeHTMLEntities(stripTags(groups[0])),
                date: date,
                pdfURL: url
            )
        }
    }

    private func matches(pattern: String, in text: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)
        return regex.matches(in: text, range: fullRange).map { match in
            (1..<match.numberOfRanges).compactMap { index in
                guard let range = Range(match.range(at: index), in: text) else { return nil }
                return String(text[range])
            }
        }
    }

    private func decodeJSONString(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\\\"")
        guard let data = "\"\(escaped)\"".data(using: .utf8),
              let decoded = try? JSONDecoder().decode(String.self, from: data)
        else { return value.replacingOccurrences(of: "\\/", with: "/") }
        return decoded
    }

    private func stripTags(_ value: String) -> String {
        value.replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func decodeHTMLEntities(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
    }

    private func normalized(_ value: String) -> String {
        value.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private func unique(_ notes: [ReleaseNote]) -> [ReleaseNote] {
        var seen = Set<URL>()
        return notes.filter { seen.insert($0.pdfURL).inserted }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
