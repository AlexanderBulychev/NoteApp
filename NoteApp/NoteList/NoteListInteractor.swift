
protocol NoteListBusinessLogic {
    func getSavedNotes()
    func fetchNetworkNotes()
//    func doSomething(request: NoteList.ShowNotes.Request)
}

protocol NoteListDataStore {
    var notes: [Note] { get }
}

final class NoteListInteractor: NoteListBusinessLogic, NoteListDataStore {
    var notes: [Note] = []

    var presenter: NoteListPresentationLogic?
    var worker: NoteListWorker?

    func getSavedNotes() {
        notes = StorageManager.shared.getNotes()
        let response = NoteList.ShowNotes.Response(notes: notes)
        presenter?.presentNotes(response: response)
    }

    func fetchNetworkNotes() {
    }

//    func doSomething(request: NoteList.ShowNotes.Request) {
//        switch request {
//        case .getNotes:
//            fetchNotes()
//        }
//    }
//
//    private func fetchNotes() {
//        worker = NoteListWorker()
//        worker?.doSomeWork()
//
//        // по комплишину передать данные в презентер
//        let response = NoteList.ShowNotes.Response()
//        presenter?.presentSomething(response: response)
//    }
}
