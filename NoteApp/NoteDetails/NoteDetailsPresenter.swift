import Foundation
protocol NoteDetailsPresentationLogic {
    func presentNoteDetails(response: NoteDetails.Response.ResponseType)
}

final class NoteDetailsPresenter: NoteDetailsPresentationLogic {
    weak var viewController: NoteDetailsDisplayLogic?

    func presentNoteDetails(response: NoteDetails.Response.ResponseType) {
        switch response {
        case .presentNoteDetails(note: let note):
            viewController?.displayNoteDetails(viewModel: .displayNoteDetails(
                noteHeader: note?.header ?? "",
                noteText: note?.text ?? "",
                noteDate: formatDate(date: note?.date)))
        case .checkNote(isEmpty: let isEmpty):
            if isEmpty {
                viewController?.displayNoteDetails(viewModel: .showAlert)
            }
        }
    }

    private func formatDate(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YYYY EEEE HH:mm"
        return formatter.string(from: date)
    }
}
