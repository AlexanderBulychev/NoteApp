//
//  NoteListInteractorTests.swift
//  NoteApp
//
//  Created by asbul on 23.06.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import NoteApp
import XCTest

class NoteListInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    private var sut: NoteListInteractor!
    private var presenter: NoteListPresentationLogicSpy!
    private var worker: NoteListWorkerSpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()

        let noteListInteractor = NoteListInteractor()
        let noteListPresenter = NoteListPresentationLogicSpy()
        let noteListWorker = NoteListWorkerSpy()

        noteListInteractor.worker = noteListWorker
        noteListInteractor.presenter = noteListPresenter

        sut = noteListInteractor
        presenter = noteListPresenter
        worker = noteListWorker
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        worker = nil
        super.tearDown()
    }
    
    // MARK: Tests
    
    func testGetNetworkNotes() {
        // Given
        
        // When
        sut.makeRequest(request: .getNetworkNotes)

        // Then
        XCTAssertTrue(worker.isCalledFetchNetworkNotes, "Not started worker.fetchNetworkNotes()")
        XCTAssertEqual(sut.notes.count, worker.networkNotes.count, "FetchedNotes are not added")
        XCTAssertTrue(presenter.isCalledPresentNotes, "Not started presenter.presentNotes()")
    }

    func testGetStoredNotes() {
        sut.makeRequest(request: .getStoredNotes)

        XCTAssertTrue(worker.isCalledGetSavedNotes, "Not started worker.getSavedNotes()")
        XCTAssertEqual(sut.notes.count, worker.notes.count, "StoredNotes are not added")
        XCTAssertTrue(presenter.isCalledPresentNotes, "Not started presenter.presentNotes()")
    }

    func testGetNotes() {
        sut.makeRequest(request: .getNotes)

        XCTAssertTrue(presenter.isCalledPresentNotes, "Not started presenter.presentNotes()")
    }

    func testSwitchIsEditMode() {
        // Given
        sut.isEditMode = true
        sut.selectedNotesIds = ["One", "Two", "Three"]

        // When
        sut.makeRequest(request: .switchIsEditMode)

        // Then
        XCTAssertFalse(sut.isEditMode, "isEditMode shouldn't be changed")
        XCTAssertTrue(sut.selectedNotesIds.isEmpty, "switch isEditMode to false should remove all selectedNotesIds")
        XCTAssertTrue(presenter.isCalledPresentNotes, "Not started presenter.presentNotes()")
    }

    func testSwitchNoteSelection() {
        // Given
        let mockNotes = [
            Note(header: "Note1", text: "Text1", date: .now, userShareIcon: nil),
            Note(header: "Note2", text: "Text2", date: .now, userShareIcon: nil)
        ]
        let expectationIndex = 1

        // When
        sut.notes = mockNotes
        sut.makeRequest(request: .switchNoteSelection(idx: expectationIndex))

        // Then
        XCTAssertFalse(sut.selectedNotesIds.isEmpty, "switchNoteSelection didn't refresh array of selectedNotesIds")
        XCTAssertTrue(presenter.isCalledPresentNotes, "Not started presenter.presentNotes()")

        // When
        sut.makeRequest(request: .switchNoteSelection(idx: expectationIndex))

        // Then
        XCTAssertTrue(sut.selectedNotesIds.isEmpty, "switchNoteSelection remove chosenNoteId at repeatable index")
    }

    func testDeleteChosenNotes() {
        // Given
        let mockNotes = [
            Note(header: "Note1", text: "Text1", date: .now, userShareIcon: nil),
            Note(header: "Note2", text: "Text2", date: .now, userShareIcon: nil),
            Note(header: "Note3", text: "Text3", date: .now, userShareIcon: nil),
            Note(header: "Note4", text: "Text4", date: .now, userShareIcon: nil)
        ]
        let mockSelectedNotesIds = [
            mockNotes[1].id,
            mockNotes[3].id
        ]

        // When
        sut.notes = mockNotes
        sut.selectedNotesIds = mockSelectedNotesIds
        sut.isEditMode = true
        sut.makeRequest(request: .deleteChosenNotes)

        // Then
        XCTAssertTrue(worker.isCalledDeleteChosenNotes, "Not started worker.deleteChosenNotes()")
        XCTAssertNotEqual(mockNotes.count, sut.notes.count, "Notes to be shown should be filtered out")
        XCTAssertTrue(sut.selectedNotesIds.isEmpty, "All selectedNotesIds should be removed after filtering")
        XCTAssertFalse(sut.isEditMode, "isEditMode is not not switched from true to false")
        XCTAssertTrue(presenter.isCalledPresentNotes, "Not started presenter.presentNotes()")


        // When
        sut.makeRequest(request: .deleteChosenNotes)

        // Then
        XCTAssertTrue(presenter.isCalledPresentNotes, "Not started presenter.presentNotes() when selectedNotesIds is empty")
    }
}
