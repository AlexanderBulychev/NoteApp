//
//  NoteListConfigurator.swift
//  NoteApp
//
//  Created by asbul on 07.06.2022.
//

import Foundation

final class NoteListConfigurator {
    static let shared = NoteListConfigurator()

    func configure(with view: NoteListViewController) {
        let interactor = NoteListInteractor()
        let presenter = NoteListPresenter()
        let router = NoteListRouter()
        view.interactor = interactor
        view.router = router
        interactor.presenter = presenter
        presenter.viewController = view
        router.viewController = view
        router.dataStore = interactor
    }
}
