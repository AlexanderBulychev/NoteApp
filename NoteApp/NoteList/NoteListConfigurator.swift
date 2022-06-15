//
//  NoteListConfigurator.swift
//  NoteApp
//
//  Created by asbul on 07.06.2022.
//

import Foundation
import UIKit

final class NoteListConfigurator {
//    static let shared = NoteListConfigurator()

    static func configure() -> UIViewController {
        let view = NoteListViewController()
        let interactor = NoteListInteractor()
        let presenter = NoteListPresenter()
        let router = NoteListRouter()
        let worker = NoteListWorker()

        view.interactor = interactor
        view.router = router

        interactor.presenter = presenter
        interactor.worker = worker

        presenter.viewController = view
        router.viewController = view
        router.dataStore = interactor
        return view
    }
}
