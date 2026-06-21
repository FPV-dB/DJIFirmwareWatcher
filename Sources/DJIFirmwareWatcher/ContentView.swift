import AppKit
import DJIFirmwareWatcherCore
import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: WatcherManager

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            productList
            Divider()
            footer
        }
        .frame(width: 560, height: 720)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("DJI Firmware Watcher", systemImage: "antenna.radiowaves.left.and.right")
                    .font(.title2.weight(.semibold))
                Spacer()
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help("Quit")
            }

            HStack {
                Button(action: manager.checkNow) {
                    Label(manager.isChecking ? "Checking..." : "Check Now", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
                .disabled(manager.isChecking)

                if manager.isChecking {
                    ProgressView().controlSize(.small)
                }

                Spacer()
                Button("All", action: manager.selectAll)
                Button("None", action: manager.selectNone)
            }

            HStack {
                Text(manager.statusMessage)
                Spacer()
                if let date = manager.state.lastChecked {
                    Text("Last checked \(date.formatted(date: .abbreviated, time: .shortened))")
                } else {
                    Text("Not checked yet")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Text("Checks selected products automatically once every 24 hours while the app is running.")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(14)
    }

    private var productList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 14, pinnedViews: [.sectionHeaders]) {
                ForEach(ProductCatalog.categories, id: \.self) { category in
                    Section {
                        ForEach(manager.products.filter { $0.category == category }) { product in
                            productRow(product)
                        }
                    } header: {
                        Text(category)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 6)
                            .background(.regularMaterial)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 12)
        }
    }

    private func productRow(_ product: DJIProduct) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Toggle("", isOn: Binding(
                get: { manager.isSelected(product) },
                set: { manager.setSelected($0, product: product) }
            ))
            .labelsHidden()

            VStack(alignment: .leading, spacing: 3) {
                Text(product.name).fontWeight(.medium)
                resultText(product)
                    .font(.caption)
                    .foregroundStyle(resultColor(product))
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            if manager.state.lastSeenByProductID[product.id] != nil {
                Button {
                    manager.openNewestRelease(for: product)
                } label: {
                    Image(systemName: "doc.richtext")
                }
                .buttonStyle(.borderless)
                .help("Open newest release notes PDF")
            }

            Button {
                manager.openDownloads(for: product)
            } label: {
                Image(systemName: "safari")
            }
            .buttonStyle(.borderless)
            .help("Open DJI downloads page")
        }
        .padding(.vertical, 3)
    }

    private func resultText(_ product: DJIProduct) -> Text {
        guard let result = manager.results[product.id] else {
            if let note = manager.state.lastSeenByProductID[product.id] {
                return Text("Latest: \(note.date.formatted(date: .abbreviated, time: .omitted))")
            }
            return Text("Waiting to check")
        }

        switch result {
        case .found(let note, let isNew):
            let prefix = isNew ? "NEW: " : "Latest: "
            return Text(prefix + note.date.formatted(date: .abbreviated, time: .omitted))
        case .noReleaseNotes:
            return Text("No matching product release notes found")
        case .failed(let message):
            return Text(message)
        }
    }

    private func resultColor(_ product: DJIProduct) -> Color {
        guard let result = manager.results[product.id] else { return .secondary }
        switch result {
        case .found(_, let isNew): return isNew ? .green : .secondary
        case .noReleaseNotes: return .orange
        case .failed: return .red
        }
    }

    private var footer: some View {
        HStack {
            Text("Release-note history is stored locally on this Mac.")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(manager.state.selectedProductIDs.count) selected")
                .font(.caption)
        }
        .padding(12)
    }
}
