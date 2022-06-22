import Foundation

protocol NoteDetailsBusinessLogic {
    func provideNoteDetails(request: NoteDetails.Request.RequestType)
}

protocol NoteDetailsDataStore {
    var note: Note? { get set }
    var isEditingNote: Bool { get }
}

final class NoteDetailsInteractor: NoteDetailsDataStore {
    var presenter: NoteDetailsPresentationLogic?
    var worker: NoteDetailsWorkerProtocol?

    var note: Note?
    lazy var isEditingNote: Bool = (note != nil) ? true : false

}

extension NoteDetailsInteractor: NoteDetailsBusinessLogic {
    func provideNoteDetails(request: NoteDetails.Request.RequestType) {
        switch request {
        case .provideNoteDetails:
            presenter?.presentNoteDetails(response: .presentNoteDetails(note: note))

        case .saveNote(noteHeader: let noteHeader, noteText: let noteText, noteDate: let noteDate):
            if isEditingNote {
                note?.header = noteHeader
                note?.text = noteText
                note?.date = noteDate
            } else {
                note = Note(
                    header: noteHeader,
                    text: noteText,
                    date: noteDate,
                    userShareIcon: nil
                )
            }
            guard let note = note else { return }
            presenter?.presentNoteDetails(response: .checkNote(isEmpty: note.isEmpty))

        case .saveNoteForPassing(noteHeader: let noteHeader, noteText: let noteText, noteDate: let noteDate):
            if isEditingNote {
                note?.header = noteHeader
                note?.text = noteText
                note?.date = noteDate
            } else {
                note = Note(
                    header: noteHeader,
                    text: noteText,
                    date: noteDate,
                    userShareIcon: nil
                )
            }
            guard let note = note, !note.isEmpty else { return }
            worker?.save(note: note)
        }
    }
}
