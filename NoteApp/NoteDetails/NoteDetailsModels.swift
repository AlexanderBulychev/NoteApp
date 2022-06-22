import Foundation

enum NoteDetails {
    struct Request {
        enum RequestType {
            case provideNoteDetails
            case saveNote(
                noteHeader: String,
                noteText: String,
                noteDate: Date
            )
            case saveNoteForPassing(
                noteHeader: String,
                noteText: String,
                noteDate: Date
            )
        }
    }
    struct Response {
        enum ResponseType {
            case presentNoteDetails(note: Note?)
            case checkNote(isEmpty: Bool)
        }
    }
    struct ViewModel {
        enum ViewModelData {
            case displayNoteDetails(
                noteHeader: String,
                noteText: String,
                noteDate: String
            )
            case showAlert
        }
    }
}

enum NoteDetail {
    // MARK: Use cases
    enum ShowNoteDetails {
        struct Response {
            let noteHeader: String?
            let noteText: String?
            let noteDate: Date?
        }

        struct ViewModel {
            let noteHeader: String
            let noteText: String
            let noteDate: String
        }
    }

    enum CheckNoteIsEmpty {
        struct Request {
            let noteHeader: String
            let noteText: String
            let noteDate: Date
        }

        struct Response {
            let isEmptyNote: Bool
        }

        struct ViewModel {
            let isEmptyNote: Bool
        }
    }

    enum PassNote {
        struct Request {
            let noteHeader: String
            let noteText: String
            let noteDate: Date
        }
    }
}
