import UIKit

protocol NoteListDisplayLogic: AnyObject {
    func displayNotes(viewModel: NoteList.ShowNotes.ViewModel)
    func displaySavedNotes(viewModel: NoteList.ShowSavedNotes.ViewModel)
    func displayNetworkNotes(viewModel: NoteList.ShowNetworkNotes.ViewModel)
}

protocol NoteViewControllerDelegateProtocol: AnyObject {
    func addNote(_ note: Note, _ isEditing: Bool)
}

final class NoteListViewController: UIViewController {
    // MARK: - Stored data properties

    var cellViewModels: [CellViewModel] = []

    private var tableViewModel: TableViewModel = TableViewModel(notes: [])
    private var selectedNotesId: [String] = []

    // MARK: - UI Elements

    private var tableView = UITableView()
    private var createNewDeleteButton = UIButton()
    private var rightBarButtonItem = UIBarButtonItem()
    private let activityIndicator = UIActivityIndicatorView()

    private var createNewNoteButtonBottomConstraint: NSLayoutConstraint!
    private var createNewNoteButtonTrailingConstraint: NSLayoutConstraint!

    // MARK: - Supporting Properties

    private let viewBackgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    private let noteCellName = "NoteCell"

    var interactor: NoteListBusinessLogic?
    var router: (NSObjectProtocol & NoteListRoutingLogic & NoteListDataPassing)?

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("class ListVC has been created")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("class ListVC has been deallocated")
        // ListVC is RootVC, so class ListVC will be deallocated when the application is closed
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = viewBackgroundColor
        title = "Заметки"
        navigationItem.backButtonTitle = ""

        setupUI()
//        NoteListConfigurator.shared.configure(with: self)

        fetchSavedNotes()
        fetchNetworkNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createNewNoteButtonTrailingConstraint.constant += 70
        createNewNoteButtonBottomConstraint.constant += 110
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAppearance()
        showNotes()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if createNewNoteButtonBottomConstraint.constant == 50 {
            createNewNoteButtonBottomConstraint.constant -= 110
        }
    }

    private func showNotes() {
        interactor?.showNotes()
    }

    private func fetchSavedNotes() {
        interactor?.fetchSavedNotes()
    }

    private func fetchNetworkNotes() {
        activityIndicator.startAnimating()
        interactor?.fetchNetworkNotes()
    }

// MARK: - Configure UI Methods
    private func setupUI() {
        configureTableView()
        configureCreateNewDeleteButton()
        configureRightBarButtonItem()
        configureActivityIndicator()
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.register(NoteCell.self, forCellReuseIdentifier: noteCellName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 94
        tableView.separatorStyle = .none
        tableView.backgroundColor = viewBackgroundColor

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureCreateNewDeleteButton() {
        view.addSubview(createNewDeleteButton)
        let noteButtonImage = UIImage(named: "button")
        createNewDeleteButton.setImage(noteButtonImage, for: .normal)

        createNewDeleteButton.translatesAutoresizingMaskIntoConstraints = false
        createNewNoteButtonTrailingConstraint = createNewDeleteButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20
        )
        createNewNoteButtonBottomConstraint = createNewDeleteButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: -60
        )

        NSLayoutConstraint.activate([createNewNoteButtonTrailingConstraint,
                                     createNewNoteButtonBottomConstraint])
        createNewDeleteButton.addTarget(self, action: #selector(createNewDeleteButtonPressed), for: .touchUpInside)
    }

    private func configureRightBarButtonItem() {
        rightBarButtonItem.title = "Выбрать"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(rightBarButtonItemAction)
    }

    private func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - @objc methods
        @objc func createNewDeleteButtonPressed() {
            if !tableViewModel.isEditTable {
                animatePushing()
            } else {
                if !selectedNotesId.isEmpty {
                    tableViewModel.cellViewModels = tableViewModel.cellViewModels.filter {
                        !selectedNotesId.contains($0.note.id)
                    }
                    StorageManager.shared.deleteNotes(at: selectedNotesId)
                    selectedNotesId.removeAll()
                    tableView.reloadData()
                } else {
                    showAlert()
                    return
                }
                tableViewModel.isEditTable.toggle()
                switchMode(for: tableViewModel.isEditTable)
            }
        }

        @objc func rightBarButtonItemAction() {
//            interactor
            tableViewModel.isEditTable.toggle()
            tableViewModel.deselectCells()
            tableView.reloadData()
            switchMode(for: tableViewModel.isEditTable)
        }

    // MARK: - Animation Methods
    private func animateAppearance() {
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: []) {
                // animations are not retained by self so there is no risk of strong retain cycle
                self.createNewNoteButtonTrailingConstraint.constant -= 70
                self.createNewNoteButtonBottomConstraint.constant -= 110
                self.view.layoutIfNeeded()
        }
    }

    private func animatePushing() {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: []
        ) {
            self.addKeyFrames()
        } completion: { _ in
            self.router?.routeToNoteDetailsForCreating()
        }
    }

    private func addKeyFrames() {
        UIView.addKeyframe(
            withRelativeStartTime: 0,
            relativeDuration: 0.5) {
                self.createNewNoteButtonBottomConstraint.constant -= 10
                self.view.layoutIfNeeded()
        }
        UIView.addKeyframe(
            withRelativeStartTime: 0.25,
            relativeDuration: 0.5) {
                self.createNewNoteButtonBottomConstraint.constant += 120
                self.view.layoutIfNeeded()
        }
    }

    private func animateSelection(_ isEdit: Bool) {
        UIView.transition(
            with: createNewDeleteButton,
            duration: 0.5,
            options: [.transitionFlipFromRight]) {
                if isEdit {
                    let noteButtonImage = UIImage(named: "deleteButton")
                    self.createNewDeleteButton.setImage(noteButtonImage, for: .normal)
                } else {
                    let noteButtonImage = UIImage(named: "button")
                    self.createNewDeleteButton.setImage(noteButtonImage, for: .normal)
                }
        }
    }

    // MARK: - Private methods
        private func showAlert() {
            let alert = UIAlertController(
                title: "",
                message: "Вы не выбрали ни одной заметки",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }

        private func switchMode(for isEdit: Bool) {
            animateSelection(isEdit)
            if isEdit {
                rightBarButtonItem.title = "Готово"
            } else {
                rightBarButtonItem.title = "Выбрать"
            }
        }

        private func updateSelectedNotesId(indexPath: IndexPath) {
            let idForChosenNote = tableViewModel.getCurrentCellViewModel(indexPath).note.id
            if tableViewModel.isChosen(indexPath) {
                selectedNotesId.append(idForChosenNote)
            } else {
                let idx = selectedNotesId.firstIndex { $0 == idForChosenNote }
                if let idx = idx {
                    selectedNotesId.remove(at: idx)
                }
            }
        }
}

// MARK: - UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: noteCellName,
            for: indexPath
        ) as? NoteCell else { return UITableViewCell() }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configureCell(from: cellViewModel)
        cell.backgroundColor = viewBackgroundColor
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewModel.isEditTable {
            tableViewModel.toggleCellSelection(indexPath)
            updateSelectedNotesId(indexPath: indexPath)
            let cell = tableView.cellForRow(at: indexPath) as? NoteCell
            cell?.configureCell(from: tableViewModel.getCurrentCellViewModel(indexPath))
            tableView.reloadData()
        } else {
            router?.routeToNoteDetailsForEditing(at: indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NoteListViewController: NoteViewControllerDelegateProtocol {
    func addNote(_ note: Note, _ isEditing: Bool) {
        if !isEditing {
            tableViewModel.addNote(note)
        }
        tableView.reloadData()
    }
}

extension NoteListViewController: NoteListDisplayLogic {
    func displayNotes(viewModel: NoteList.ShowNotes.ViewModel) {
        cellViewModels = viewModel.cellviewModels
        tableView.reloadData()
    }

    func displaySavedNotes(viewModel: NoteList.ShowSavedNotes.ViewModel) {
        cellViewModels = viewModel.cellViewModels
        tableView.reloadData()
    }

    func displayNetworkNotes(viewModel: NoteList.ShowNetworkNotes.ViewModel) {
        cellViewModels = viewModel.cellViewModels
        let delay = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
