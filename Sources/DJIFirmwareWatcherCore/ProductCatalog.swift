import Foundation

public enum ProductCatalog {
    public static let products: [DJIProduct] = [
        product("dji-mini", "DJI Mini", "Consumer Drones - Mini", "https://www.dji.com/downloads/products/mavic-mini", ["DJI Mavic Mini", "Mavic Mini"]),
        product("dji-mini-se", "DJI Mini SE", "Consumer Drones - Mini", "https://www.dji.com/downloads/products/mini-se"),
        product("dji-mini-2", "DJI Mini 2", "Consumer Drones - Mini", "https://www.dji.com/downloads/products/mini-2"),
        product("dji-mini-2-se", "DJI Mini 2 SE", "Consumer Drones - Mini", "https://www.dji.com/downloads/products/mini-2-se"),
        product("dji-mini-3", "DJI Mini 3", "Consumer Drones - Mini", "https://www.dji.com/downloads/products/mini-3"),
        product("dji-mini-3-pro", "DJI Mini 3 Pro", "Consumer Drones - Mini", "https://www.dji.com/downloads/products/mini-3-pro"),
        product("dji-mini-4-pro", "DJI Mini 4 Pro", "Consumer Drones - Mini", "https://www.dji.com/downloads/products/mini-4-pro"),
        product("dji-mini-4k", "DJI Mini 4K", "Consumer Drones - Mini", "https://www.dji.com/mini-2-se/downloads"),

        product("dji-mavic-air-2", "DJI Mavic Air 2", "Consumer Drones - Air", "https://www.dji.com/downloads/products/mavic-air-2", ["DJI Mavic Air 2", "Mavic Air 2"]),
        product("dji-air-2s", "DJI Air 2S", "Consumer Drones - Air", "https://www.dji.com/downloads/products/air-2s"),
        product("dji-air-3", "DJI Air 3", "Consumer Drones - Air", "https://www.dji.com/downloads/products/air-3"),
        product("dji-air-3s", "DJI Air 3S", "Consumer Drones - Air", "https://www.dji.com/downloads/products/air-3s"),

        product("dji-mavic-3", "DJI Mavic 3", "Consumer Drones - Mavic", "https://www.dji.com/downloads/products/mavic-3"),
        product("dji-mavic-3-cine", "DJI Mavic 3 Cine", "Consumer Drones - Mavic", "https://www.dji.com/downloads/products/mavic-3", ["DJI Mavic 3", "Mavic 3"]),
        product("dji-mavic-3-classic", "DJI Mavic 3 Classic", "Consumer Drones - Mavic", "https://www.dji.com/downloads/products/mavic-3-classic"),
        product("dji-mavic-3-pro", "DJI Mavic 3 Pro", "Consumer Drones - Mavic", "https://www.dji.com/downloads/products/mavic-3-pro"),
        product("dji-mavic-3-pro-cine", "DJI Mavic 3 Pro Cine", "Consumer Drones - Mavic", "https://www.dji.com/downloads/products/mavic-3-pro", ["DJI Mavic 3 Pro", "Mavic 3 Pro"]),
        product("dji-mavic-4-pro", "DJI Mavic 4 Pro", "Consumer Drones - Mavic", "https://www.dji.com/downloads/products/mavic-4-pro"),

        product("dji-neo", "DJI Neo", "Consumer Drones - New Lines", "https://www.dji.com/neo/downloads"),
        product("dji-neo-2", "DJI Neo 2", "Consumer Drones - New Lines", "https://www.dji.com/neo-2/downloads"),
        product("dji-flip", "DJI Flip", "Consumer Drones - New Lines", "https://www.dji.com/flip/downloads"),
        product("dji-lito-1", "DJI Lito 1", "Consumer Drones - New Lines", "https://www.dji.com/lito-1/downloads"),
        product("dji-lito-x1", "DJI Lito X1", "Consumer Drones - New Lines", "https://www.dji.com/lito-x1/downloads"),

        product("dji-fpv", "DJI FPV", "FPV Drones", "https://www.dji.com/dji-fpv/downloads"),
        product("dji-avata", "DJI Avata", "FPV Drones", "https://www.dji.com/avata/downloads"),
        product("dji-avata-2", "DJI Avata 2", "FPV Drones", "https://www.dji.com/avata-2/downloads"),

        product("mavic-2-enterprise-advanced", "DJI Mavic 2 Enterprise Advanced", "Enterprise - Mavic", "https://enterprise.dji.com/mavic-2-enterprise-advanced/downloads"),
        product("mavic-3-enterprise", "DJI Mavic 3 Enterprise", "Enterprise - Mavic", "https://enterprise.dji.com/mavic-3-enterprise/downloads", ["DJI Mavic 3 Enterprise", "Mavic 3 Enterprise"]),
        product("mavic-3-thermal", "DJI Mavic 3 Thermal", "Enterprise - Mavic", "https://enterprise.dji.com/mavic-3-enterprise/downloads", ["DJI Mavic 3 Enterprise Series", "Mavic 3 Enterprise Series"]),

        product("matrice-30", "DJI Matrice 30", "Enterprise - Matrice", "https://enterprise.dji.com/matrice-30/downloads", ["DJI Matrice 30 Series", "Matrice 30 Series"]),
        product("matrice-30t", "DJI Matrice 30T", "Enterprise - Matrice", "https://enterprise.dji.com/matrice-30/downloads", ["DJI Matrice 30 Series", "Matrice 30 Series"]),
        product("matrice-350-rtk", "DJI Matrice 350 RTK", "Enterprise - Matrice", "https://enterprise.dji.com/matrice-350-rtk/downloads"),
        product("matrice-3d", "DJI Matrice 3D", "Enterprise - Matrice", "https://enterprise.dji.com/dock-2/downloads", ["DJI Dock 2", "Dock 2", "DJI Matrice 3D Series", "Matrice 3D Series"]),
        product("matrice-3td", "DJI Matrice 3TD", "Enterprise - Matrice", "https://enterprise.dji.com/dock-2/downloads", ["DJI Dock 2", "Dock 2", "DJI Matrice 3D Series", "Matrice 3D Series"]),
        product("matrice-4e", "DJI Matrice 4E", "Enterprise - Matrice", "https://enterprise.dji.com/matrice-4-series/downloads", ["DJI Matrice 4 Series", "Matrice 4 Series"]),
        product("matrice-4t", "DJI Matrice 4T", "Enterprise - Matrice", "https://enterprise.dji.com/matrice-4-series/downloads", ["DJI Matrice 4 Series", "Matrice 4 Series"]),
        product("matrice-4d", "DJI Matrice 4D", "Enterprise - Matrice", "https://enterprise.dji.com/dock-3/downloads", ["DJI Dock 3", "Dock 3", "DJI Matrice 4D Series", "Matrice 4D Series"]),
        product("matrice-4td", "DJI Matrice 4TD", "Enterprise - Matrice", "https://enterprise.dji.com/dock-3/downloads", ["DJI Dock 3", "Dock 3", "DJI Matrice 4D Series", "Matrice 4D Series"]),

        product("inspire-3", "DJI Inspire 3", "Enterprise - Inspire", "https://www.dji.com/inspire-3/downloads"),

        product("rc-n1", "DJI RC-N1", "Controllers - Consumer", "https://www.dji.com/mini-2/downloads", ["DJI Mini 2", "Mini 2"]),
        product("rc-n2", "DJI RC-N2", "Controllers - Consumer", "https://www.dji.com/mini-4-pro/downloads", ["DJI Mini 4 Pro", "Mini 4 Pro"]),
        product("dji-rc", "DJI RC", "Controllers - Consumer", "https://www.dji.com/rc/downloads"),
        product("dji-rc-2", "DJI RC 2", "Controllers - Consumer", "https://www.dji.com/rc-2/downloads"),
        product("dji-rc-pro", "DJI RC Pro", "Controllers - Consumer", "https://www.dji.com/rc-pro/downloads"),
        product("dji-rc-pro-2", "DJI RC Pro 2", "Controllers - Consumer", "https://www.dji.com/rc-pro-2/downloads"),
        product("dji-rc-plus", "DJI RC Plus", "Controllers - Enterprise", "https://enterprise.dji.com/matrice-30/downloads", ["DJI Matrice 30 Series", "Matrice 30 Series"]),
        product("dji-rc-plus-2", "DJI RC Plus 2", "Controllers - Enterprise", "https://enterprise.dji.com/matrice-4-series/downloads", ["DJI Matrice 4 Series", "Matrice 4 Series"]),
        product("fpv-remote-controller-2", "DJI FPV Remote Controller 2", "Controllers - FPV", "https://www.dji.com/dji-fpv/downloads"),
        product("fpv-remote-controller-3", "DJI FPV Remote Controller 3", "Controllers - FPV", "https://www.dji.com/avata-2/downloads"),

        product("goggles-v2", "DJI Goggles V2", "Goggles", "https://www.dji.com/dji-fpv/downloads"),
        product("goggles-2", "DJI Goggles 2", "Goggles", "https://www.dji.com/goggles-2/downloads"),
        product("goggles-integra", "DJI Goggles Integra", "Goggles", "https://www.dji.com/goggles-integra/downloads"),
        product("goggles-3", "DJI Goggles 3", "Goggles", "https://www.dji.com/goggles-3/downloads"),
        product("goggles-n3", "DJI Goggles N3", "Goggles", "https://www.dji.com/goggles-n3/downloads"),

        product("o3-air-unit", "DJI O3 Air Unit", "Air Units", "https://www.dji.com/o3-air-unit/downloads"),
        product("o4-air-unit", "DJI O4 Air Unit", "Air Units", "https://www.dji.com/o4-air-unit/downloads", ["DJI O4 Air Unit Series", "O4 Air Unit Series"]),
        product("o4-air-unit-pro", "DJI O4 Air Unit Pro", "Air Units", "https://www.dji.com/o4-air-unit/downloads", ["DJI O4 Air Unit Series", "O4 Air Unit Series"]),
        product("o4-ground-station", "DJI O4 Ground Station", "Air Units", "https://enterprise.dji.com/o4-ground-station/downloads")
    ]

    public static var categories: [String] {
        Array(Set(products.map(\.category))).sorted()
    }

    private static func product(
        _ id: String,
        _ name: String,
        _ category: String,
        _ url: String,
        _ matchingTerms: [String]? = nil
    ) -> DJIProduct {
        DJIProduct(
            id: id,
            name: name,
            category: category,
            downloadsURL: URL(string: url)!,
            matchingTerms: matchingTerms
        )
    }
}
