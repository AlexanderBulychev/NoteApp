//
//  Note.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import Foundation

struct Note: Codable {
    let header: String?
    let body: String?

    // let data: Data
    var isEmpty: Bool {
            header == nil && body == nil
    }
}
