import SwiftUI

@main
struct DJIFirmwareWatcherApp: App {
    @StateObject private var manager = WatcherManager()

    var body: some Scene {
        MenuBarExtra {
            ContentView(manager: manager)
        } label: {
            Image(nsImage: MenuBarIcon.image)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 15)
                .accessibilityLabel("DJI Firmware Watcher")
        }
        .menuBarExtraStyle(.window)

        Window("Manage Models", id: "model-picker") {
            ModelPickerWindow(manager: manager)
        }
        .defaultSize(width: 860, height: 680)
    }
}
