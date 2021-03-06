import Foundation

protocol NoteListWorkerProtocol {
    func getSavedNotes() -> [Note]
    func fetchNetworkNotes(completion: @escaping ([NetworkNote]) -> Void)
    func deleteChosenNotes(at ids: [String])
}

final class NoteListWorker: NoteListWorkerProtocol {
    func getSavedNotes() -> [Note] {
        StorageManager.shared.getNotes()
    }

    func fetchNetworkNotes(completion: @escaping ([NetworkNote]) -> Void) {
        NetworkManager.shared.fetchNotes { networkNotes in
            completion(networkNotes)
        } failureCompletion: { error in
            print(error)
        }
    }

    func deleteChosenNotes(at ids: [String]) {
        StorageManager.shared.deleteNotes(at: ids)
    }
}
