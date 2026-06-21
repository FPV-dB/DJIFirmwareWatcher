import DJIFirmwareWatcherCore
import SwiftUI

struct FirmwareStatusRow: View {
    let product: DJIProduct
    @ObservedObject var manager: WatcherManager
    var showsCheckbox: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if showsCheckbox {
                Toggle("", isOn: Binding(
                    get: { manager.isSelected(product) },
                    set: { manager.setSelected($0, product: product) }
                ))
                .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(product.name)
                    .font(.callout.weight(.medium))
                    .lineLimit(1)

                if showsCheckbox {
                    Text(product.category)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }

                Text(statusText)
                    .font(.caption)
                    .foregroundStyle(statusColor)
                    .lineLimit(1)
            }

            Spacer(minLength: 6)

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
                Image(systemName: "arrow.up.right.square")
            }
            .buttonStyle(.borderless)
            .help("Open DJI downloads page")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private var statusText: String {
        guard let result = manager.results[product.id] else {
            if let note = manager.state.lastSeenByProductID[product.id] {
                return "Latest release notes: \(note.date.formatted(date: .abbreviated, time: .omitted))"
            }
            return "Waiting for first check"
        }

        switch result {
        case .found(let note, let isNew):
            return "\(isNew ? "New" : "Latest") release notes: \(note.date.formatted(date: .abbreviated, time: .omitted))"
        case .noReleaseNotes:
            return "No matching release notes found"
        case .failed(let message):
            return message
        }
    }

    private var statusColor: Color {
        guard let result = manager.results[product.id] else { return .secondary }
        switch result {
        case .found(_, let isNew): return isNew ? .green : .secondary
        case .noReleaseNotes: return .orange
        case .failed: return .red
        }
    }
}
