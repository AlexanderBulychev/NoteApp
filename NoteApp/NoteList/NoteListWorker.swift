import Foundation

protocol NoteListWorkerProtocol {
    func getNotes() -> [Note]
    func fetchNetworkNotes(completion: @escaping ([NetworkNote]) -> Void)
    func fetchNoteIconImageData(from urls: [String?], completion: @escaping ([Data]) -> Void)
}

final class NoteListWorker: NoteListWorkerProtocol {
    private var storageManager: StorageManagerProtocol?
    private var networkManager: NetworkManagerProtocol?

    func getNotes() -> [Note] {
        storageManager?.getNotes() ?? []
    }

    func fetchNetworkNotes(completion: @escaping ([NetworkNote]) -> Void) {
        networkManager?.fetchNotes(successCompletion: { networkNotes in
            completion(networkNotes)
        }, failureCompletion: { error in
            print(error)
        })
    }

    func fetchNoteIconImageData(from urls: [String?], completion: @escaping ([Data]) -> Void) {
        var networkNotesImages: [Data] = []
        let group = DispatchGroup()
        for index in 0 ..< urls.count {
            group.enter()
            networkManager?.fetchNoteIconImageData(
                from: urls[index],
                successCompletion: { imageData in
                    networkNotesImages.append(imageData)
                    group.leave()
                },
                failureCompletion: { error in
                    print(error)
                    group.leave()
                }
            )
        }
        group.notify(queue: .global()) {
            completion(networkNotesImages)
        }
    }
}
