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

//    func switchOfIsChosen() {
//        viewModels.forEach { viewModel in
//            viewModel.isChosen = false
//        }
//    }
}

struct CellViewModel {
    var note: Note
    var isShifted: Bool = false
    static var isEdited: Bool = false
    var isChosen: Bool = false
}

final class Note: Codable {
    let id: String
    var header: String
    var body: String
    var isEmpty: Bool {
        header == "" && body == ""
    }
    var date: Date

    init(header: String, body: String, date: Date) {
        self.header = header
        self.body = body
        self.date = date
        self.id = UUID().uuidString
    }
}
