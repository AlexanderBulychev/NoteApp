//
//  StorageManager.swift
//  NoteApp
//
//  Created by asbul on 28.03.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults()
    private init() {}
}
