//
//  Note.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import Foundation

class Note: Codable {
    let header: String
    let body: String
    let date: Date

    var isEmpty: Bool {
            header == "" && body == ""
    }
    init(header: String, body: String, date: Date) {
        self.header = header
        self.body = body
        self.date = date
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.header == rhs.header &&
        lhs.body == rhs.body
    }
}
