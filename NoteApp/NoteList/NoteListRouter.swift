import UIKit

@objc protocol NoteListRoutingLogic {
    func routeToNoteDetailsForEditing(at index: Int)
    func routeToNoteDetailsForCreating()
}

protocol NoteListDataPassing {
    var dataStore: NoteListDataStore? { get }
}

final class NoteListRouter: NSObject, NoteListRoutingLogic, NoteListDataPassing {
    weak var viewController: NoteListViewController?
    var dataStore: NoteListDataStore?

    // MARK: Routing
    func routeToNoteDetailsForEditing(at index: Int) {
        let noteDetailsVC = NoteDetailsViewController()
        guard let dataStore = dataStore, var destinationDS = noteDetailsVC.router?.dataStore else { return }
        passDataToNoteDetails(source: dataStore, destination: &destinationDS, at: index)
        viewController?.navigationController?.pushViewController(
            noteDetailsVC,
            animated: true
        )
    }
    func routeToNoteDetailsForCreating() {
        let noteDetailsVC = NoteDetailsViewController()
        viewController?.navigationController?.pushViewController(
            noteDetailsVC,
            animated: true
        )
    }

    // MARK: Passing data
    func passDataToNoteDetails(
        source: NoteListDataStore,
        destination: inout NoteDetailsDataStore,
        at index: Int
    ) {
        destination.note = source.notes[index]
    }
}
