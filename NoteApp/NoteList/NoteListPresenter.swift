import Foundation

protocol NoteListPresentationLogic {
    func presentNotes(response: NoteList.Response.ResponseType)
}

final class NoteListPresenter: NoteListPresentationLogic {
    weak var viewController: NoteListDisplayLogic?

    func presentNotes(response: NoteList.Response.ResponseType) {
        switch response {
        case .presentStoredNotes(notes: let notes, isEditMode: let isEditMode):
            let cells = notes.map { configureCellViewModel(from: $0, isEditMode: isEditMode) }
            let noteListViewModel: NoteListViewModel = NoteListViewModel(cells: cells)
            viewController?.displayNotes(viewModel: .displayStoredNotes(noteListViewModel: noteListViewModel))
        case .presentNetworkNotes(newNotes: let newNotes, isEditMode: let isEditMode):
            let cells = newNotes.map { configureCellViewModel(from: $0, isEditMode: isEditMode) }
            let noteListViewModel: NoteListViewModel = NoteListViewModel(cells: cells)
            viewController?.displayNotes(viewModel: .displayNetworkNotes(noteListViewModel: noteListViewModel))
        case .presentNotes(notes: let notes, isEditMode: let isEditMode):
            let cells = notes.map { configureCellViewModel(from: $0, isEditMode: isEditMode) }
            var noteListViewModel: NoteListViewModel = NoteListViewModel(cells: cells)
            noteListViewModel.isEditMode = isEditMode
            viewController?.displayNotes(viewModel: .displayNotes(noteListViewModel: noteListViewModel))
        case .presentCellSelection(idx: let idx):
            viewController?.displayNotes(viewModel: .displayCellSelection(idx: idx))
        case .presentNoSelection:
            viewController?.displayNotes(viewModel: .displayNoSelection)
        }
    }

    private func configureCellViewModel(from note: Note, isEditMode: Bool) -> NoteListViewModel.Cell {
        NoteListViewModel.Cell(
            header: note.header,
            text: note.text,
            date: formatDate(date: note.date),
            userShareIcon: note.userShareIcon,
            isEdited: isEditMode,
            isChosen: false
        )
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YYYY"
        return formatter.string(from: date)
    }
}
