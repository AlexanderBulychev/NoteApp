import Foundation

final class Note: Codable {
    let id: String
    var header: String
    var text: String
    var isEmpty: Bool {
        header == "" && text == ""
    }
    var date: Date
    var userShareIcon: String?

    required init(header: String, text: String, date: Date, userShareIcon: String?) {
        self.header = header
        self.text = text
        self.date = date
        self.id = UUID().uuidString
        self.userShareIcon = userShareIcon

        print("Class Note was created")
    }

    deinit {
        print("Class Note has been deallocated")
    }
}

struct NetworkNote: Codable {
    let header: String
    let text: String
    let date: Date
    var userShareIcon: String?
}
