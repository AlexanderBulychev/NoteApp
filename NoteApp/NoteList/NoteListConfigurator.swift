import Foundation
import UIKit

final class NoteListConfigurator {
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
