// swiftlint disable: all
import Foundation

enum NoteList {
    struct Request {
        enum RequestType {
            case getNotes
            case getStoredNotes
            case getNetworkNotes
            case switchIsEditMode
            case switchNoteSelection(idx: Int)
        }
    }
    struct Response {
        enum ResponseType {
            case presentStoredNotes(notes: [Note], isEditMode: Bool)
            case presentNetworkNotes(newNotes: [Note], isEditMode: Bool)
            case presentNotes(notes: [Note], isEditMode: Bool)
//            case presentEditMode(notes: [Note], isEditMode: Bool)
            case presentCellSelection(idx: Int)
        }
    }
    struct ViewModel {
        enum ViewModelData {
            case displayStoredNotes(noteListViewModel: NoteListViewModel)
            case displayNetworkNotes(noteListViewModel: NoteListViewModel)
            case displayNotes(noteListViewModel: NoteListViewModel)
            case displayCellSelection(idx: Int)
        }
    }
}

struct NoteListViewModel {
    struct Cell: NoteCellViewModelProtocol {
        var header: String
        var text: String
        var date: String
        var userShareIcon: String?
        var isEdited: Bool
        var isChosen: Bool
    }
    var cells: [Cell]
    var isEditMode: Bool = false
}
