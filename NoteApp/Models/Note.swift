//
//  Note.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import Foundation

struct TableViewModel {
    var isEditTable: Bool = false {
        didSet {
            CellViewModel.isEdited = isEditTable
        }
    }

    var cellsCount: Int {
        viewModels.count
    }

    private var notes: [Note]
    var viewModels: [CellViewModel]

    init(notes: [Note]) {
        self.notes = notes
        self.viewModels = notes.map { CellViewModel(note: $0) }
    }

    func viewModel(_ indexPath: IndexPath) -> CellViewModel {
        viewModels[indexPath.row]
    }

    mutating func selectCell(_ indexPath: IndexPath) {
        viewModels[indexPath.row].isChosen.toggle()
    }

    mutating func addNote(_ note: Note) {
        notes.append(note)
        viewModels.append(.init(note: note))
    }

    func isChosen(_ indexPath: IndexPath) -> Bool {
        viewModels[indexPath.row].isChosen == true
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
