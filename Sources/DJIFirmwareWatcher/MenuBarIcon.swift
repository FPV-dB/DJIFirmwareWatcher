import AppKit

enum MenuBarIcon {
    static let image: NSImage = {
        guard let url = Bundle.main.url(forResource: "DJIMenuBarIcon", withExtension: "png"),
              let image = NSImage(contentsOf: url)
        else {
            return NSImage(systemSymbolName: "airplane", accessibilityDescription: "DJI Firmware Watcher")!
        }

        image.size = NSSize(width: 26, height: 15)
        image.isTemplate = true
        image.accessibilityDescription = "DJI Firmware Watcher"
        return image
    }()
}
