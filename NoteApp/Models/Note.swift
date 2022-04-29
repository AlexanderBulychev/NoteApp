//
//  Note.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import Foundation

class Note: Codable {
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
