import SwiftUI

class MainViewModel: ObservableObject {
    @Published var tabs: [TabItem] = []
    @Published var activeTabId: UUID?
    @Published var showAddSheet: Bool = false

    let windowConfig = WindowConfig()

    var activeTab: TabItem? {
        tabs.first { $0.id == activeTabId }
    }

    func addTab(_ tab: TabItem) {
        tabs.append(tab)
        activeTabId = tab.id
        saveTabs()
    }

    func removeTab(id: UUID) {
        tabs.removeAll { $0.id == id }
        if activeTabId == id {
            activeTabId = tabs.last?.id
        }
        saveTabs()
    }

    func selectTab(id: UUID) {
        activeTabId = id
    }

    func addWebTab(urlString: String) {
        guard let url = URL(string: urlString), let host = url.host else { return }
        let tab = TabItem(
            title: host,
            type: .web,
            url: url
        )
        addTab(tab)
    }

    func addFileTab() {
        FileOpener.openFile { fileURL, contentType in
            DispatchQueue.main.async {
                let title = fileURL.deletingPathExtension().lastPathComponent
                let tab = TabItem(title: title, type: contentType, url: fileURL)
                self.addTab(tab)
            }
        }
    }

    // MARK: - Persistence

    func saveTabs() {
        guard let data = try? JSONEncoder().encode(tabs) else { return }
        UserDefaults.standard.set(data, forKey: "savedTabs")
        if let activeId = activeTabId {
            UserDefaults.standard.set(activeId.uuidString, forKey: "activeTabId")
        }
    }

    func loadTabs() {
        guard let data = UserDefaults.standard.data(forKey: "savedTabs"),
              let saved = try? JSONDecoder().decode([TabItem].self, from: data) else { return }
        tabs = saved
        if let activeIdString = UserDefaults.standard.string(forKey: "activeTabId"),
           let activeId = UUID(uuidString: activeIdString) {
            activeTabId = activeId
        } else {
            activeTabId = tabs.first?.id
        }
    }
}
