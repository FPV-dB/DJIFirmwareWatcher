import DJIFirmwareWatcherCore
import SwiftUI

struct ModelPickerWindow: View {
    @ObservedObject var manager: WatcherManager
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedFilter: ModelFilter = .all

    private var visibleProducts: [DJIProduct] {
        manager.products
            .filter { selectedFilter.includes($0, manager: manager) }
            .filter { product in
                searchText.isEmpty
                    || product.name.localizedCaseInsensitiveContains(searchText)
                    || product.category.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private var sections: [ModelSection] {
        var result: [ModelSection] = []
        let selected = visibleProducts.filter(manager.isSelected)
        if !selected.isEmpty {
            result.append(ModelSection(title: "My Selected Products", products: selected))
        }

        guard selectedFilter != .selected else { return result }
        let unselected = visibleProducts.filter { !manager.isSelected($0) }
        let groups = selectedFilter == .all ? ModelGroup.allCases : selectedFilter.groups
        for group in groups {
            let products = unselected.filter(group.includes)
            if !products.isEmpty {
                result.append(ModelSection(title: group.title, products: products))
            }
        }
        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            controls
            Divider()
            modelList
            Divider()
            actionBar
        }
        .frame(minWidth: 760, minHeight: 560)
        .navigationTitle("Manage DJI Models")
    }

    private var controls: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search products or categories", text: $searchText)
                    .textFieldStyle(.roundedBorder)
            }

            Picker("Category", selection: $selectedFilter) {
                ForEach(ModelFilter.allCases) { filter in
                    Text(filter.title).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(14)
    }

    private var modelList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                    Color.clear.frame(height: 0).id("model-list-top")

                    ForEach(sections) { section in
                        Section {
                            ForEach(section.products) { product in
                                FirmwareStatusRow(product: product, manager: manager, showsCheckbox: true)
                                Divider().padding(.leading, 44)
                            }
                        } header: {
                            HStack {
                                Text(section.title).font(.headline)
                                Spacer()
                                Text(section.products.count.formatted())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(.regularMaterial)
                        }
                    }

                    if sections.isEmpty {
                        ContentUnavailableView(
                            "No Matching Products",
                            systemImage: "magnifyingglass",
                            description: Text("Try a different search or category.")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    }
                }
                .padding(14)
            }
            .onAppear { scrollToTop(proxy) }
            .onChange(of: selectedFilter) { _, _ in scrollToTop(proxy) }
            .onChange(of: searchText) { _, _ in scrollToTop(proxy) }
        }
    }

    private func scrollToTop(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            proxy.scrollTo("model-list-top", anchor: .top)
        }
    }

    private var actionBar: some View {
        HStack {
            Button("Select All Visible") {
                manager.setSelected(true, products: visibleProducts)
            }
            .disabled(visibleProducts.isEmpty)

            Button("Clear Visible") {
                manager.setSelected(false, products: visibleProducts)
            }
            .disabled(visibleProducts.isEmpty)

            Spacer()

            Text("\(manager.selectedProducts.count) selected")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
        }
        .padding(14)
    }
}

private struct ModelSection: Identifiable {
    let title: String
    let products: [DJIProduct]
    var id: String { title }
}

private enum ModelGroup: String, CaseIterable {
    case consumer
    case fpvAir
    case controllers
    case goggles
    case enterprise

    var title: String {
        switch self {
        case .consumer: return "Consumer Drones"
        case .fpvAir: return "FPV / Air Units"
        case .controllers: return "Controllers"
        case .goggles: return "Goggles"
        case .enterprise: return "Enterprise"
        }
    }

    func includes(_ product: DJIProduct) -> Bool {
        switch self {
        case .consumer: return product.category.hasPrefix("Consumer Drones")
        case .fpvAir: return product.category == "FPV Drones" || product.category == "Air Units"
        case .controllers: return product.category.hasPrefix("Controllers")
        case .goggles: return product.category == "Goggles"
        case .enterprise: return product.category.hasPrefix("Enterprise")
        }
    }
}

private enum ModelFilter: String, CaseIterable, Identifiable {
    case all
    case selected
    case consumer
    case fpvAir
    case controllers
    case goggles
    case enterprise

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "All"
        case .selected: return "Selected"
        case .consumer: return "Consumer"
        case .fpvAir: return "FPV / Air"
        case .controllers: return "Controllers"
        case .goggles: return "Goggles"
        case .enterprise: return "Enterprise"
        }
    }

    var groups: [ModelGroup] {
        switch self {
        case .consumer: return [.consumer]
        case .fpvAir: return [.fpvAir]
        case .controllers: return [.controllers]
        case .goggles: return [.goggles]
        case .enterprise: return [.enterprise]
        case .all, .selected: return []
        }
    }

    @MainActor
    func includes(_ product: DJIProduct, manager: WatcherManager) -> Bool {
        switch self {
        case .all: return true
        case .selected: return manager.isSelected(product)
        default: return groups.contains { $0.includes(product) }
        }
    }
}
