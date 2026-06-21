import AppKit
import DJIFirmwareWatcherCore
import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: WatcherManager
    @Environment(\.openWindow) private var openWindow

    private var selectedProducts: [DJIProduct] {
        manager.selectedProducts.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private var popoverHeight: CGFloat {
        min(620, max(250, 190 + CGFloat(selectedProducts.count) * 58))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()

            if selectedProducts.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(selectedProducts) { product in
                            FirmwareStatusRow(product: product, manager: manager, showsCheckbox: false)
                            Divider().padding(.leading, 12)
                        }
                    }
                }
            }

            Divider()
            footer
        }
        .frame(width: 430, height: popoverHeight)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("DJI Firmware Watcher")
                    .font(.headline)
                Spacer()
                if manager.isChecking {
                    ProgressView().controlSize(.small)
                }
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Image(systemName: "power")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help("Quit DJI Firmware Watcher")
            }

            HStack(spacing: 8) {
                Button(action: manager.checkNow) {
                    Label(manager.isChecking ? "Checking…" : "Check Now", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
                .disabled(manager.isChecking || selectedProducts.isEmpty)

                Button {
                    openWindow(id: "model-picker")
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Label("Manage Models…", systemImage: "slider.horizontal.3")
                }
                .buttonStyle(.bordered)
            }

            Text(manager.statusMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(12)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "checklist.unchecked")
                .font(.title2)
                .foregroundStyle(.secondary)
            Text("Choose DJI products to watch.")
                .font(.callout.weight(.medium))
            Button("Manage Models…") {
                openWindow(id: "model-picker")
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var footer: some View {
        HStack {
            if let date = manager.state.lastChecked {
                Text("Checked \(date.formatted(date: .abbreviated, time: .shortened))")
            } else {
                Text("Not checked yet")
            }
            Spacer()
            Text("\(selectedProducts.count) watched")
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .padding(10)
    }
}
