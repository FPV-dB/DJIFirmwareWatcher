import AppKit
import Combine
import DJIFirmwareWatcherCore
import Foundation
import UserNotifications

@MainActor
final class WatcherManager: ObservableObject {
    @Published private(set) var state: WatcherState
    @Published private(set) var results: [String: ProductCheckResult] = [:]
    @Published private(set) var isChecking = false
    @Published private(set) var statusMessage = "Ready"

    let products = ProductCatalog.products

    private let store: JSONStateStore
    private let parser = ReleaseNoteParser()
    private var dailyTimer: Timer?

    init(store: JSONStateStore = JSONStateStore()) {
        self.store = store
        var loaded = store.load()
        if !FileManager.default.fileExists(atPath: store.fileURL.path) {
            loaded.selectedProductIDs = Set(products.map(\.id))
        } else if (loaded.catalogVersion ?? 1) < 2 {
            loaded.selectedProductIDs.insert("dji-neo-2")
        }
        loaded.catalogVersion = 2
        state = loaded
        try? store.save(loaded)
        requestNotificationPermission()
        scheduleDailyChecks()

        Task { [weak self] in
            await self?.checkIfDailyCheckIsDue()
        }
    }

    func isSelected(_ product: DJIProduct) -> Bool {
        state.selectedProductIDs.contains(product.id)
    }

    func setSelected(_ selected: Bool, product: DJIProduct) {
        if selected {
            state.selectedProductIDs.insert(product.id)
        } else {
            state.selectedProductIDs.remove(product.id)
        }
        saveState()
    }

    func selectAll() {
        state.selectedProductIDs = Set(products.map(\.id))
        saveState()
    }

    func selectNone() {
        state.selectedProductIDs.removeAll()
        saveState()
    }

    func checkNow() {
        Task { await checkSelectedProducts() }
    }

    func openNewestRelease(for product: DJIProduct) {
        guard let note = state.lastSeenByProductID[product.id] else { return }
        NSWorkspace.shared.open(note.pdfURL)
    }

    func openDownloads(for product: DJIProduct) {
        NSWorkspace.shared.open(product.downloadsURL)
    }

    private func checkIfDailyCheckIsDue() async {
        let interval: TimeInterval = 24 * 60 * 60
        guard state.lastChecked.map({ Date().timeIntervalSince($0) >= interval }) ?? true else { return }
        await checkSelectedProducts()
    }

    private func scheduleDailyChecks() {
        dailyTimer = Timer.scheduledTimer(withTimeInterval: 60 * 60, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.checkIfDailyCheckIsDue()
            }
        }
    }

    private func checkSelectedProducts() async {
        guard !isChecking else { return }
        let selected = products.filter(isSelected)
        guard !selected.isEmpty else {
            statusMessage = "Select at least one product"
            return
        }

        isChecking = true
        statusMessage = "Checking \(selected.count) products..."
        defer { isChecking = false }

        let grouped = Dictionary(grouping: selected, by: \.downloadsURL)
        var fetchedPages: [URL: Result<String, Error>] = [:]

        await withTaskGroup(of: (URL, Result<String, Error>).self) { group in
            for url in grouped.keys {
                group.addTask {
                    do {
                        var request = URLRequest(url: url)
                        request.timeoutInterval = 30
                        request.setValue("DJI Firmware Watcher/1.0 (macOS)", forHTTPHeaderField: "User-Agent")
                        let (data, response) = try await URLSession.shared.data(for: request)
                        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                            throw CheckError.badStatus((response as? HTTPURLResponse)?.statusCode ?? 0)
                        }
                        guard let html = String(data: data, encoding: .utf8) else {
                            throw CheckError.invalidText
                        }
                        return (url, .success(html))
                    } catch {
                        return (url, .failure(error))
                    }
                }
            }

            for await (url, result) in group {
                fetchedPages[url] = result
            }
        }

        var updateCount = 0
        for product in selected {
            guard let pageResult = fetchedPages[product.downloadsURL] else { continue }
            switch pageResult {
            case .failure(let error):
                results[product.id] = .failed(error.localizedDescription)
            case .success(let html):
                guard let newest = parser.newestReleaseNote(in: html, for: product) else {
                    results[product.id] = .noReleaseNotes
                    continue
                }

                let previous = state.lastSeenByProductID[product.id]
                let isNew = previous.map {
                    newest.date > $0.date || (newest.date == $0.date && newest.pdfURL != $0.pdfURL)
                } ?? false
                state.lastSeenByProductID[product.id] = newest
                results[product.id] = .found(newest, isNew: isNew)

                if isNew {
                    updateCount += 1
                    sendNotification(product: product, note: newest)
                }
            }
        }

        state.lastChecked = Date()
        saveState()
        statusMessage = updateCount == 0 ? "No new release notes" : "Found \(updateCount) update\(updateCount == 1 ? "" : "s")"
    }

    private func saveState() {
        do {
            try store.save(state)
        } catch {
            statusMessage = "Could not save: \(error.localizedDescription)"
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    private func sendNotification(product: DJIProduct, note: ReleaseNote) {
        let content = UNMutableNotificationContent()
        content.title = "New DJI release notes"
        content.body = "\(product.name): \(note.title)"
        content.sound = .default
        content.userInfo = ["url": note.pdfURL.absoluteString]
        let request = UNNotificationRequest(identifier: product.id + note.pdfURL.absoluteString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

private enum CheckError: LocalizedError {
    case badStatus(Int)
    case invalidText

    var errorDescription: String? {
        switch self {
        case .badStatus(let code): return "DJI page returned HTTP \(code)"
        case .invalidText: return "DJI page was not valid text"
        }
    }
}
