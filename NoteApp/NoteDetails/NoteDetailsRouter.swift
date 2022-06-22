import UIKit

@objc protocol NoteDetailsRoutingLogic {
    func routeToNoteList()
}

protocol NoteDetailsDataPassing {
    var dataStore: NoteDetailsDataStore? { get }
}

final class NoteDetailsRouter: NSObject, NoteDetailsRoutingLogic, NoteDetailsDataPassing {
    weak var viewController: NoteDetailsViewController?
    var dataStore: NoteDetailsDataStore?

    // MARK: - Routing
    func routeToNoteList() {
        let parentVC = viewController?.navigationController?.viewControllers.first {
            $0 is NoteListViewController
        } as? NoteListViewController

        let parentDS = parentVC?.router?.dataStore

        guard let dataStore = dataStore, var parentDS = parentDS else {
            return
        }
        passDataToNoteList(source: dataStore, destination: &parentDS)
    }

    // MARK: - Passing data
    func passDataToNoteList(
        source: NoteDetailsDataStore,
        destination: inout NoteListDataStore
    ) {
        guard let currentNote = source.note else { return }
        let index = destination.notes.firstIndex { $0.id == currentNote.id }
        if let index = index {
            destination.notes[index] = currentNote
        } else {
            destination.notes.append(currentNote)
        }
    }
}
