
protocol NoteListWorkerProtocol {

    func fetchNotes(completion @escaping: ([NetworkNote]) -> Void)

}

final class NoteListWorker: NoteListWorkerProtocol {

    private var networkManager: NetworkManager

    func fetchNotes() {
        networkManager.fetchNotes(successCompletion: completion, failureCompletion: <#T##(NetworkError) -> Void#>)
    }

}
