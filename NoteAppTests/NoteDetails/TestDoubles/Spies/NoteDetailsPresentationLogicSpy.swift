//
//  NoteDetailsPresentationLogicSpy.swift
//  NoteAppTests
//
//  Created by asbul on 27.06.2022.
//

import Foundation
@testable import NoteApp

final class NoteDetailsPresentationLogicSpy: NoteDetailsPresentationLogic {

    private(set) var isCalledPresentNote = false

    func presentNoteDetails(response: NoteDetails.Response.ResponseType) {
        isCalledPresentNote = true
    }
}
