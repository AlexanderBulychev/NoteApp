import Foundation

protocol NoteDetailsWorkerProtocol {
    func save(note: Note)
}

final class NoteDetailsWorker: NoteDetailsWorkerProtocol {
    func save(note: Note) {
        StorageManager.shared.save(note: note)
    }
}
