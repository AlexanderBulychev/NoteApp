import UIKit

protocol NoteListDisplayLogic: AnyObject {
    func displayNotes(viewModel: NoteList.ViewModel.ViewModelData)
}

final class NoteListViewController: UIViewController {
    var interactor: NoteListBusinessLogic?
    var router: (NSObjectProtocol & NoteListRoutingLogic & NoteListDataPassing)?

    // MARK: - Stored data properties
    private var noteListViewModel: NoteListViewModel = NoteListViewModel(cells: [])

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

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = viewBackgroundColor
        title = "Заметки"
        navigationItem.backButtonTitle = ""

        setupUI()
        getStoredNotes()
        getNetworkNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .getNotes)
        createNewNoteButtonTrailingConstraint.constant += 70
        createNewNoteButtonBottomConstraint.constant += 110
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAppearance()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if createNewNoteButtonBottomConstraint.constant == 50 {
            createNewNoteButtonBottomConstraint.constant -= 110
        }
    }

    private func getStoredNotes() {
        interactor?.makeRequest(request: .getStoredNotes)
    }

    private func getNetworkNotes() {
        activityIndicator.startAnimating()
        interactor?.makeRequest(request: .getNetworkNotes)
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
            if !noteListViewModel.isEditMode {
                animatePushing()
            } else {
                interactor?.makeRequest(request: .deleteChosenNotes)
            }
        }

        @objc func rightBarButtonItemAction() {
            interactor?.makeRequest(request: .switchIsEditMode)
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
}

// MARK: - UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteListViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: noteCellName,
            for: indexPath
        ) as? NoteCell else { return UITableViewCell() }
        let cellViewModel = noteListViewModel.cells[indexPath.row]
        cell.configure(from: cellViewModel)
        cell.backgroundColor = viewBackgroundColor
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if noteListViewModel.isEditMode {
            interactor?.makeRequest(request: .switchNoteSelection(idx: indexPath.row))
        } else {
            router?.routeToNoteDetailsForEditing(at: indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NoteListViewController: NoteListDisplayLogic {
    func displayNotes(viewModel: NoteList.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayStoredNotes(noteListViewModel: let listViewModel):
            self.noteListViewModel = listViewModel
            tableView.reloadData()
        case .displayNetworkNotes(noteListViewModel: let noteListViewModel):
            self.noteListViewModel.cells.append(contentsOf: noteListViewModel.cells)
            tableView.reloadData()
            activityIndicator.stopAnimating()
        case .displayNotes(noteListViewModel: let noteListViewModel):
            self.noteListViewModel = noteListViewModel
            switchMode(for: noteListViewModel.isEditMode)
            tableView.reloadData()
        case .displayCellSelection(idx: let idx):
            noteListViewModel.cells[idx].isChosen.toggle()
            tableView.reloadData()
        case .displayNoSelection:
            showAlert()
        }
    }
}
