import SwiftUI

@main
struct DJIFirmwareWatcherApp: App {
    @StateObject private var manager = WatcherManager()

    var body: some Scene {
        MenuBarExtra {
            ContentView(manager: manager)
        } label: {
            Label("DJI Firmware Watcher", systemImage: manager.isChecking ? "arrow.triangle.2.circlepath" : "airplane")
        }
        .menuBarExtraStyle(.window)
    }
}
