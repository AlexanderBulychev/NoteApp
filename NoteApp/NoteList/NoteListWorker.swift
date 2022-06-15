import Foundation

protocol NoteListWorkerProtocol {
    func getNotes() -> [Note]
    func fetchNetworkNotes(completion: @escaping ([NetworkNote]) -> Void)
    func fetchNoteIconImageData(from urls: [String?], completion: @escaping ([Data?]) -> Void)
}

final class NoteListWorker: NoteListWorkerProtocol {
    func getNotes() -> [Note] {
        StorageManager.shared.getNotes()
    }

    func fetchNetworkNotes(completion: @escaping ([NetworkNote]) -> Void) {
        NetworkManager.shared.fetchNotes { networkNotes in
            completion(networkNotes)
        } failureCompletion: { error in
            print(error)
        }
    }

    func fetchNoteIconImageData(from urls: [String?], completion: @escaping ([Data?]) -> Void) {
        var networkNotesImages: [Data?] = []
        let group = DispatchGroup()
        for index in 0 ..< urls.count {
            group.enter()

            NetworkManager.shared.fetchNoteIconImageData(
                from: urls[index],
                successCompletion: { imageData in
                    networkNotesImages.append(imageData)
                    group.leave()
                },
                failureCompletion: { error in
                    print(error)
                    networkNotesImages.append(nil)
                    group.leave()
                }
            )
        }
        group.notify(queue: .global()) {
            completion(networkNotesImages)
        }
    }
}
