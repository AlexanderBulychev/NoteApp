//
//  ListViewController.swift
//  NoteApp
//
//  Created by asbul on 11.04.2022.
//

import UIKit

protocol NoteViewControllerDelegateProtocol: AnyObject {
    func addNote(_ note: Note, _ isEditing: Bool)
}

class ListViewController: UIViewController {
    var tableView = UITableView()
    var notes: [Note] = []
    private var tableViewModel: TableViewModel = TableViewModel(notes: [])
    private var selectedNotesId: [String] = []

    private let noteCellName = "NoteCell"
    private let viewBackgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    private var createNewDeleteButton = UIButton()
    private var rightBarButtonItem = UIBarButtonItem()

    private var createNewNoteButtonBottomConstraint: NSLayoutConstraint!
    private var createNewNoteButtonTrailingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        title = "Заметки"
        navigationItem.backButtonTitle = ""

        setupUI()

        notes = StorageManager.shared.getNotes()
        tableViewModel = TableViewModel(notes: notes)

        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    private func setupUI() {
        configureTableView()
        configureCreateNewDeleteButton()
        configureRightBarButtonItem()
    }

// MARK: - Configure UI Methods
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
        tableViewModel.isEditTable.toggle()
        tableViewModel.deselectCells()
        tableView.reloadData()
        switchMode(for: tableViewModel.isEditTable)
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

    private func formatDate(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YYYY EEEE HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewModel.cellsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: noteCellName,
            for: indexPath
        ) as? NoteCell else { return UITableViewCell() }
        cell.configureCell(from: tableViewModel.getCurrentCellViewModel(indexPath))
        cell.backgroundColor = viewBackgroundColor
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewModel.isEditTable {
            tableViewModel.toggleCellSelection(indexPath)
            updateSelectedNotesId(indexPath: indexPath)
            let cell = tableView.cellForRow(at: indexPath) as? NoteCell
            cell?.configureCell(from: tableViewModel.getCurrentCellViewModel(indexPath))
            tableView.reloadData()
        } else {
            let noteCell = tableViewModel.getCurrentCellViewModel(indexPath)
            let noteVC = NoteViewController()
            noteVC.note = noteCell.note
            noteVC.delegate = self
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
}

// MARK: - Animation Methods
extension ListViewController {
    private func animateAppearance() {
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: []) { [ weak self ] in
                self?.createNewNoteButtonTrailingConstraint.constant -= 70
                self?.createNewNoteButtonBottomConstraint.constant -= 110
                self?.view.layoutIfNeeded()
        }
    }

    private func animatePushing() {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: []
        ) { [ weak self ] in
            self?.addKeyFrames()
        } completion: { _ in
            let noteVC = NoteViewController()
            noteVC.delegate = self
            self.navigationController?.pushViewController(noteVC, animated: true)
        }
    }

    private func addKeyFrames() {
        UIView.addKeyframe(
            withRelativeStartTime: 0,
            relativeDuration: 0.5) { [ weak self ] in
                self?.createNewNoteButtonBottomConstraint.constant -= 10
                self?.view.layoutIfNeeded()
        }
        UIView.addKeyframe(
            withRelativeStartTime: 0.25,
            relativeDuration: 0.5) { [ weak self ] in
                self?.createNewNoteButtonBottomConstraint.constant += 120
                self?.view.layoutIfNeeded()
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
}

extension ListViewController: NoteViewControllerDelegateProtocol {
    func addNote(_ note: Note, _ isEditing: Bool) {
        if !isEditing {
            tableViewModel.addNote(note)
        }
        tableView.reloadData()
    }
}

// MARK: - Fetch data from the Network
extension ListViewController {
    private func fetchData() {
        NetworkManager.shared.fetchDataWithResult { [weak self] result in
            switch result {
            case .success(let networkNotes):
                DispatchQueue.main.async {
                    self?.tableViewModel.appendNetworkNotes(networkNotes)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
