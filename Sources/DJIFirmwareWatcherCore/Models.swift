import Foundation

public struct DJIProduct: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let category: String
    public let downloadsURL: URL
    public let matchingTerms: [String]

    public init(id: String, name: String, category: String, downloadsURL: URL, matchingTerms: [String]? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.downloadsURL = downloadsURL
        self.matchingTerms = matchingTerms ?? [name]
    }
}

public struct ReleaseNote: Codable, Hashable, Sendable {
    public let title: String
    public let date: Date
    public let pdfURL: URL

    public init(title: String, date: Date, pdfURL: URL) {
        self.title = title
        self.date = date
        self.pdfURL = pdfURL
    }
}

public struct WatcherState: Codable, Sendable {
    public var catalogVersion: Int?
    public var selectedProductIDs: Set<String>
    public var lastSeenByProductID: [String: ReleaseNote]
    public var lastChecked: Date?

    public init(
        catalogVersion: Int? = 2,
        selectedProductIDs: Set<String> = [],
        lastSeenByProductID: [String: ReleaseNote] = [:],
        lastChecked: Date? = nil
    ) {
        self.catalogVersion = catalogVersion
        self.selectedProductIDs = selectedProductIDs
        self.lastSeenByProductID = lastSeenByProductID
        self.lastChecked = lastChecked
    }
}

public enum ProductCheckResult: Sendable {
    case found(ReleaseNote, isNew: Bool)
    case noReleaseNotes
    case failed(String)
}
