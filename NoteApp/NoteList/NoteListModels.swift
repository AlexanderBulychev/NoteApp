// swiftlint disable: all
import Foundation

// typealias NoteCellViewModel = NoteList.ShowNotes.ViewModel.NoteCellViewModel

enum NoteList {
    // Request
    /* enum Request {
        case savedNotes
        case remoteNotes
    }

    enum Response {
        case note([Note])
    }

    struct ViewModel {

    }*/

    // MARK: Use cases

    enum ShowNotes {
        struct Response {
            let notes: [Note]
        }
        struct ViewModel {
            let cellviewModels: [CellViewModel]
        }
    }

    enum ShowSavedNotes {
        struct Response {
            let notes: [Note]
        }
        struct ViewModel {
            let cellViewModels: [CellViewModel]
        }
    }

    enum ShowNetworkNotes {
        struct Response {
            let networkNotes: [NetworkNote]
            let networkNoteImages: [Data?]
        }
        struct ViewModel {
            let cellViewModels: [CellViewModel]
        }
    }

    enum SwitchModeForEditing {
        struct Response {
            let isEnabled: Bool
        }
        struct ViewModel {
            let rightBarButtonTitle: String
        }
    }

    enum SelectNotesForDeleting {
        struct Request {
        }
        struct Response {
            let notes: [Note]
        }
        struct ViewModel {
            let cellViewModels: [CellViewModel]
        }
    }
}
