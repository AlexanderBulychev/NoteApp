//
//  NoteListWorkerSpy.swift
//  NoteAppTests
//
//  Created by asbul on 24.06.2022.
//

import Foundation
@testable import NoteApp

final class NoteListWorkerSpy: NoteListWorkerProtocol {
    private(set) var isCalledFetchNetworkNotes = false
    private(set) var isCalledGetSavedNotes = false
    private(set) var isCalledDeleteChosenNotes = false

    let networkNotes: [NetworkNote] = [
        NetworkNote(header: "Note1", text: "SomeText1", date: .now, userShareIcon: nil),
        NetworkNote(header: "Note2", text: "SomeText2", date: .now, userShareIcon: nil),
        NetworkNote(header: "Note3", text: "SomeText3", date: .now, userShareIcon: nil)
    ]

    let notes: [Note] = [
        Note(header: "Note1", text: "SomeText1", date: .now, userShareIcon: nil),
        Note(header: "Note2", text: "SomeText2", date: .now, userShareIcon: nil),
        Note(header: "Note3", text: "SomeText3", date: .now, userShareIcon: nil)
    ]

    func getSavedNotes() -> [Note] {
        isCalledGetSavedNotes = true
        return notes
    }

    func fetchNetworkNotes(completion: @escaping ([NetworkNote]) -> Void) {
        isCalledFetchNetworkNotes = true
        completion(networkNotes)
    }

    func deleteChosenNotes(at ids: [String]) {
        isCalledDeleteChosenNotes = true
    }
}
