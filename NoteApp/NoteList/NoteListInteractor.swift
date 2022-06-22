import Foundation

protocol NoteListBusinessLogic {
    func makeRequest(request: NoteList.Request.RequestType)
}

protocol NoteListDataStore {
    var notes: [Note] { get set }
    var isEditMode: Bool { get set }
    var selectedNotesIds: [String] { get set }
}

final class NoteListInteractor: NoteListDataStore {
    var presenter: NoteListPresentationLogic?
    var worker: NoteListWorkerProtocol?

    var notes: [Note] = []
    var isEditMode: Bool = false
    var selectedNotesIds: [String] = []
}

extension NoteListInteractor: NoteListBusinessLogic {
    func makeRequest(request: NoteList.Request.RequestType) {
        switch request {
        case .getStoredNotes:
            notes = worker?.getSavedNotes() ?? []
            presenter?.presentNotes(response: .presentStoredNotes(notes: notes, isEditMode: isEditMode))
        case .getNetworkNotes:
            worker?.fetchNetworkNotes(completion: { [weak self] networkNotes in
                guard let newNotes = self?.convert(networkNotes) else { return }
                self?.notes.append(contentsOf: newNotes)
                self?.presenter?.presentNotes(response: .presentNetworkNotes(newNotes: newNotes, isEditMode: self?.isEditMode ?? false))
            })
        case .getNotes:
            presenter?.presentNotes(response: .presentNotes(notes: notes, isEditMode: isEditMode))
        case .switchIsEditMode:
            isEditMode.toggle()
            if !isEditMode {
                selectedNotesIds = []
            }
            presenter?.presentNotes(response: .presentNotes(notes: notes, isEditMode: isEditMode))
        case .switchNoteSelection(idx: let idx):
            selectedNotesIds = collectSelectedNotes(idx: idx)
            presenter?.presentNotes(response: .presentCellSelection(idx: idx))
        case .deleteChosenNotes:
            if !selectedNotesIds.isEmpty {
                worker?.deleteChosenNotes(at: selectedNotesIds)
                notes = notes.filter { !selectedNotesIds.contains($0.id) }
                selectedNotesIds = []
                isEditMode.toggle()
                presenter?.presentNotes(response: .presentNotes(notes: notes, isEditMode: isEditMode))
            } else {
                presenter?.presentNotes(response: .presentNoSelection)
            }
        }
    }

    private func convert(_ networkNotes: [NetworkNote]) -> [Note] {
        networkNotes.map { Note(
            header: $0.header,
            text: $0.text,
            date: $0.date,
            userShareIcon: $0.userShareIcon
        )
        }
    }

    private func collectSelectedNotes(idx: Int) -> [String] {
        let currentNoteId = notes[idx].id
        let idx = selectedNotesIds.firstIndex { $0 == currentNoteId }
        if let idx = idx {
            selectedNotesIds.remove(at: idx)
        } else {
            selectedNotesIds.append(currentNoteId)
        }
        return selectedNotesIds
    }
}
