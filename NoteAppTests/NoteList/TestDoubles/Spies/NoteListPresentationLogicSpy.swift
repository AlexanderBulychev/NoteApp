//
//  NoteListPresentationLogicSpy.swift
//  NoteAppTests
//
//  Created by asbul on 24.06.2022.
//

import Foundation
@testable import NoteApp

final class NoteListPresentationLogicSpy: NoteListPresentationLogic {
    private(set) var isCalledPresentFetchedNotes = false

    func presentNotes(response: NoteList.Response.ResponseType) {
        isCalledPresentFetchedNotes = true
    }    
}
