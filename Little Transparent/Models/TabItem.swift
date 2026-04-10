import Foundation

enum ContentType: String, Codable {
    case web
    case txt
    case epub
    case video
}

struct TabItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var type: ContentType
    var url: URL?

    init(id: UUID = UUID(), title: String, type: ContentType, url: URL? = nil) {
        self.id = id
        self.title = title
        self.type = type
        self.url = url
    }
}
