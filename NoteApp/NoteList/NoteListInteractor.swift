import Foundation

protocol NoteListBusinessLogic {
    func fetchSavedNotes()
    func fetchNetworkNotes()
    func fetchNetworkNotesImageData()
}

protocol NoteListDataStore {
    var notes: [Note] { get }
    var networkNotes: [NetworkNote] { get }
    var networkNoteImages: [Data] { get }
}

final class NoteListInteractor: NoteListBusinessLogic, NoteListDataStore {
    var notes: [Note] = []
    var networkNotes: [NetworkNote] = []
    var networkNoteImages: [Data] = []

    var presenter: NoteListPresentationLogic?
    var worker: NoteListWorker?

    func fetchSavedNotes() {
        notes = worker?.getNotes() ?? []
        let response = NoteList.ShowNotes.Response(notes: notes)
        presenter?.presentNotes(response: response)
    }

    func fetchNetworkNotes() {
        worker?.fetchNetworkNotes(completion: { [weak self] networkNotes in
            self?.networkNotes = networkNotes
            self?.fetchNetworkNotesImageData()
        })
    }

    func fetchNetworkNotesImageData() {
        var networkNoteUserShareIcons: [String?] = []
        for index in 0 ..< networkNotes.count {
            networkNoteUserShareIcons.append(networkNotes[index].userShareIcon)
        }
        worker?.fetchNoteIconImageData(from: networkNoteUserShareIcons, completion: { [weak self] networkNotesImages in
            self?.networkNoteImages = networkNotesImages
        })
        let response = NoteList.ShowNetworkNotes.Response(
            networkNotes: networkNotes,
            networkNoteImages: networkNoteImages
        )
        presenter?.presentNetworkNotes(response: response)
    }
}
