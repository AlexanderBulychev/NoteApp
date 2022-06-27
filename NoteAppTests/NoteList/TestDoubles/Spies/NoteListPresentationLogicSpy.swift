//
//  NoteListPresentationLogicSpy.swift
//  NoteAppTests
//
//  Created by asbul on 24.06.2022.
//

import Foundation
@testable import NoteApp

final class NoteListPresentationLogicSpy: NoteListPresentationLogic {
    private(set) var isCalledPresentNotes = false
    // for what??
//    var responseMock: NoteList.Response.ResponseType?
//    var fetchResponse: (() -> Void)?

    func presentNotes(response: NoteList.Response.ResponseType) {
        isCalledPresentNotes = true
//        responseMock = response
//        fetchResponse?()
    }    
}
