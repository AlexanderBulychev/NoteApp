//
//  StorageManager.swift
//  NoteApp
//
//  Created by asbul on 28.03.2022.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private let userDefaults = UserDefaults.standard
    private let key = "Notes"

    private init() {}

    func save(note: Note) {
        var notes = getNotes()

        let index = notes.firstIndex { $0.id == note.id }

        if let index = index {
            notes[index] = note
        } else {
            notes.append(note)
        }

        guard let data = try? JSONEncoder().encode(notes) else { return }
        userDefaults.set(data, forKey: key)
    }

    func getNotes() -> [Note] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let notes = try? JSONDecoder().decode([Note].self, from: data) else { return [] }
        return notes
    }
}
