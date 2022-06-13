import Foundation

protocol NoteListBusinessLogic {
    func fetchSavedNotes()
    func fetchNetworkNotes()
    func fetchNetworkNotesImageData()
}

protocol NoteListDataStore {
    var notes: [Note] { get }
    var networkNotes: [NetworkNote] { get }
    var networkNoteImages: [Data?] { get }
}

final class NoteListInteractor: NoteListBusinessLogic, NoteListDataStore {
    var notes: [Note] = []
    var networkNotes: [NetworkNote] = []
    var networkNoteImages: [Data?] = []

    var presenter: NoteListPresentationLogic?
    var worker: NoteListWorkerProtocol?

    func fetchSavedNotes() {
        worker = NoteListWorker()
        notes = worker?.getNotes() ?? []
        let response = NoteList.ShowNotes.Response(notes: notes)
        presenter?.presentNotes(response: response)
    }

    func fetchNetworkNotes() {
        worker = NoteListWorker()
        worker?.fetchNetworkNotes(completion: { [weak self] networkNotes in
            self?.networkNotes = networkNotes
            self?.appendNetworkNotes(networkNotes)
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
            let response = NoteList.ShowNetworkNotes.Response(
                networkNotes: self?.networkNotes ?? [],
                networkNoteImages: self?.networkNoteImages ?? []
            )
            self?.presenter?.presentNetworkNotes(response: response)
        })
    }

    private func appendNetworkNotes(_ networkNotes: [NetworkNote]) {
        let newNotes = networkNotes.map { Note(
            header: $0.header,
            text: $0.text,
            date: $0.date,
            userShareIcon: $0.userShareIcon
        )
        }
        notes.append(contentsOf: newNotes)
    }
}
