//
//  NoteDetailsWorkerSpy.swift
//  NoteAppTests
//
//  Created by asbul on 27.06.2022.
//

import Foundation
@testable import NoteApp

final class NoteDetailsWorkerSpy: NoteDetailsWorkerProtocol {

    private(set) var isCalledSaveNote = false

    func save(note: Note) {
        isCalledSaveNote = true
    }
}
