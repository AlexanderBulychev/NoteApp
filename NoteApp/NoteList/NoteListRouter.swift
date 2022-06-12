//
//  NoteListRouter.swift
//  NoteApp
//
//  Created by asbul on 07.06.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol NoteListRoutingLogic {
    func routeToNoteDetailsForEditingNote(at index: Int)
}

protocol NoteListDataPassing {
    var dataStore: NoteListDataStore? { get }
}

class NoteListRouter: NSObject, NoteListRoutingLogic, NoteListDataPassing {
    weak var viewController: NoteListViewController?
    var dataStore: NoteListDataStore?

    // MARK: Routing
    func routeToNoteDetailsForEditingNote(at index: Int) {
        let noteDetailsVC = NoteDetailsViewController()
        guard let dataStore = dataStore, var destinationDS = noteDetailsVC.router?.dataStore else { return }
        passDataToNoteDetails(source: dataStore, destination: &destinationDS, at: index)
        viewController?.navigationController?.pushViewController(
            noteDetailsVC,
            animated: true
        )
    }

    // MARK: Passing data
    func passDataToNoteDetails(
        source: NoteListDataStore,
        destination: inout NoteDetailsDataStore,
        at index: Int
    ) {
        destination.note = source.notes[index]
    }
}
