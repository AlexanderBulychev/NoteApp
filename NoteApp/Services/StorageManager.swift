//
//  StorageManager.swift
//  NoteApp
//
//  Created by asbul on 28.03.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()

    private let userDefaults = UserDefaults.standard
    private let key = "Notes"

    private init() {}

    func saveNote(note: Note) {
        guard let data = try? JSONEncoder().encode(note) else { return }
        userDefaults.set(data, forKey: key)
    }

    func getNote() -> Note? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        guard let note = try? JSONDecoder().decode(Note.self, from: data) else { return nil }
        return note
    }
}
