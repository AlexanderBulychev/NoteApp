//
//  Note.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import Foundation

class Note: Codable {
    var header: String
    var body: String
    var date: Date

    var isEmpty: Bool {
            header == "" && body == ""
    }
    init(header: String, body: String, date: Date) {
        self.header = header
        self.body = body
        self.date = date
    }
}
