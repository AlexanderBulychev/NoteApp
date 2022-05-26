//
//  Note.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import Foundation

struct TableViewModel {
    var cellViewModels: [CellViewModel]
    var isEditTable: Bool = false {
        didSet {
            CellViewModel.isEdited = isEditTable
        }
    }
    var cellsCount: Int {
        cellViewModels.count
    }
    private var notes: [Note]

    init(notes: [Note]) {
        self.notes = notes
        self.cellViewModels = notes.map { CellViewModel(note: $0) }
    }

    func getCurrentCellViewModel(_ indexPath: IndexPath) -> CellViewModel {
        cellViewModels[indexPath.row]
    }

    mutating func toggleCellSelection(_ indexPath: IndexPath) {
        cellViewModels[indexPath.row].isChosen.toggle()
    }

    mutating func addNote(_ note: Note) {
        notes.append(note)
        cellViewModels.append(.init(note: note))
    }

    func isChosen(_ indexPath: IndexPath) -> Bool {
        cellViewModels[indexPath.row].isChosen == true
    }

    mutating func switchOfIsChosen(indexPath: IndexPath) {
        cellViewModels[indexPath.row].isChosen = false
//       cellViewModels.map { $0.isChosen = false }
    }

    mutating func deselectCells() {
//        cellViewModels = cellViewModels.map { CellViewModel(note: $0.note, isShifted: $0.isShifted, isChosen: false) }
        for index in cellViewModels.indices {
            cellViewModels[index].isChosen = false
        }
    }

    mutating func appendNetworkNotes(_ networkNotes: [NetworkNote]) {
        let newNotes = networkNotes.map { Note(
            header: $0.header,
            text: $0.text,
            date: $0.date,
            userShareIcon: $0.userShareIcon
        )
        }
        cellViewModels.append(contentsOf: newNotes.map { CellViewModel(note: $0) })
    }
}

struct CellViewModel {
    var note: Note
//    var isShifted: Bool = false
    static var isEdited: Bool = false
    var isChosen: Bool = false
}

final class Note: Codable {
    let id: String
    var header: String
    var text: String
    var isEmpty: Bool {
        header == "" && text == ""
    }
    var date: Date
    var userShareIcon: String?

    required init(header: String, text: String, date: Date, userShareIcon: String?) {
        self.header = header
        self.text = text
        self.date = date
        self.id = UUID().uuidString
        self.userShareIcon = userShareIcon

        print("Class Note was created")
    }

    deinit {
        print("Class Note has been deallocated")
    }
}

struct NetworkNote: Codable {
    let header: String
    let text: String
    let date: Date
    var userShareIcon: String?
}
