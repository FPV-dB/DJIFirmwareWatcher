import Foundation
import Testing
@testable import DJIFirmwareWatcherCore

@Test func catalogIncludesDJINeo2() {
    let neo2 = ProductCatalog.products.first { $0.id == "dji-neo-2" }

    #expect(neo2?.name == "DJI Neo 2")
    #expect(neo2?.downloadsURL.absoluteString == "https://www.dji.com/neo-2/downloads")
}

@Test func parsesStructuredDJIReleaseNote() throws {
    let html = #"""
    <script>
    {"manuals":[{"grouping_name":"unassigned","data":[{"slug":"mini-4-pro-release-notes","release_at":"2025-11-05","product_title":"DJI Mini 4 Pro","manual_category":" - Release Notes","version":"","url":"https://dl.djicdn.com/downloads/DJI_Mini_4_Pro/Release_Notes_EN.pdf"}]}]}
    </script>
    """#
    let product = ProductCatalog.products.first { $0.id == "dji-mini-4-pro" }!

    let note = ReleaseNoteParser().newestReleaseNote(in: html, for: product)

    #expect(note?.title == "DJI Mini 4 Pro - Release Notes")
    #expect(note?.pdfURL.absoluteString == "https://dl.djicdn.com/downloads/DJI_Mini_4_Pro/Release_Notes_EN.pdf")
}

@Test func ignoresGenericAssistantReleaseNotes() {
    let html = #"""
    {"release_at":"2026-04-23","product_title":"DJI Assistant 2 (Consumer Drones Series)","manual_category":" Release Notes","version":"V2.1.40","url":"https://example.com/assistant.pdf"}
    """#
    let product = ProductCatalog.products.first { $0.id == "dji-mini-4-pro" }!

    #expect(ReleaseNoteParser().newestReleaseNote(in: html, for: product) == nil)
}

@Test func parsesLegacyDJIProductPageReleaseNote() {
    let html = #"""
    <div class="groups-download-item">
      <div class="groups-items-content">
        <div id="manuals-name-1" class="groups-item-name">DJI O4 Air Unit Series - Release Notes</div>
        <div class="groups-item-date">2026-03-25</div>
      </div>
      <div class="groups-item-icons">
        <a href="https://dl.djicdn.com/downloads/DJI_O4_Air_Unit_Series/Release_Notes_en.pdf">PDF</a>
      </div>
    </div>
    """#
    let product = ProductCatalog.products.first { $0.id == "o4-air-unit" }!

    let note = ReleaseNoteParser().newestReleaseNote(in: html, for: product)

    #expect(note?.title == "DJI O4 Air Unit Series - Release Notes")
    #expect(note?.pdfURL.absoluteString.contains("DJI_O4_Air_Unit_Series") == true)
}

@Test func stateStoreRoundTrips() throws {
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let store = JSONStateStore(fileURL: directory.appendingPathComponent("state.json"))
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let note = ReleaseNote(title: "DJI Mini 4 Pro - Release Notes", date: date, pdfURL: URL(string: "https://example.com/note.pdf")!)
    let state = WatcherState(
        selectedProductIDs: ["dji-mini-4-pro"],
        lastSeenByProductID: ["dji-mini-4-pro": note],
        lastChecked: date
    )

    try store.save(state)
    let loaded = store.load()

    #expect(loaded.selectedProductIDs == state.selectedProductIDs)
    #expect(loaded.lastSeenByProductID == state.lastSeenByProductID)
    #expect(loaded.lastChecked == state.lastChecked)
}
