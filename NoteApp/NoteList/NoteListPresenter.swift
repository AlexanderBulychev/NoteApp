//
//  NoteListPresenter.swift
//  NoteApp
//
//  Created by asbul on 07.06.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol NoteListPresentationLogic {
    func presentNotes(response: NoteList.ShowNotes.Response)
    func presentSavedNotes(response: NoteList.ShowSavedNotes.Response)
    func presentNetworkNotes(response: NoteList.ShowNetworkNotes.Response)
    // func present(_ savedNotes: Note, networkNotes: NoteNetwork, images: [Images])
}

class NoteListPresenter: NoteListPresentationLogic {
    var cellViewModels: [CellViewModel] = []
    weak var viewController: NoteListDisplayLogic?

    func presentNotes(response: NoteList.ShowNotes.Response) {
        cellViewModels = response.notes.map { CellViewModel(note: $0) }
        let viewModel = NoteList.ShowNotes.ViewModel(cellviewModels: cellViewModels)
        viewController?.displayNotes(viewModel: viewModel)
    }

    func presentSavedNotes(response: NoteList.ShowSavedNotes.Response) {
        cellViewModels = response.notes.map { CellViewModel(note: $0) }
        let viewModel = NoteList.ShowSavedNotes.ViewModel(cellViewModels: cellViewModels)
        viewController?.displaySavedNotes(viewModel: viewModel)
    }

    func presentNetworkNotes(response: NoteList.ShowNetworkNotes.Response) {
        var networkNotesCellViewModels: [CellViewModel] = []
        let newNotes = response.networkNotes.map { Note(
            header: $0.header,
            text: $0.text,
            date: $0.date,
            userShareIcon: $0.userShareIcon
            )
        }
        networkNotesCellViewModels.append(contentsOf: newNotes.map { CellViewModel(note: $0) })
        for index in 0 ..< response.networkNoteImages.count {
            networkNotesCellViewModels[index].noteIconImageData = response.networkNoteImages[index]
        }
        cellViewModels.append(contentsOf: networkNotesCellViewModels)
        let viewModel = NoteList.ShowNetworkNotes.ViewModel(cellViewModels: cellViewModels)
        viewController?.displayNetworkNotes(viewModel: viewModel)
    }
}
