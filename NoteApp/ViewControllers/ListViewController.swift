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
    private var switchableButton = UIButton()
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
        configureCreateNewNoteButton()
        configureRightBarButtonItem()
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
        let topConstraint = tableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 16
        )
        let trailingConstraint = tableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor
        )
        let bottomConstraint = tableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )
        NSLayoutConstraint.activate([topConstraint,
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     trailingConstraint,
                                     bottomConstraint])
    }

    private func configureCreateNewNoteButton() {
        view.addSubview(switchableButton)
        let noteButtonImage = UIImage(named: "button")
        switchableButton.setImage(noteButtonImage, for: .normal)

        switchableButton.translatesAutoresizingMaskIntoConstraints = false
        createNewNoteButtonTrailingConstraint = switchableButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20
        )
        createNewNoteButtonBottomConstraint = switchableButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: -60
        )
        NSLayoutConstraint.activate([createNewNoteButtonTrailingConstraint,
                                     createNewNoteButtonBottomConstraint])
        switchableButton.addTarget(self, action: #selector(createNewDeleteButtonPressed), for: .touchUpInside)
    }

    @objc func createNewDeleteButtonPressed() {
        if !tableViewModel.isEditTable {
            animatePushing()
        } else {
            if !selectedNotesId.isEmpty {
            tableViewModel.cellViewModels = tableViewModel.cellViewModels.filter { !selectedNotesId.contains($0.note.id) }
            StorageManager.shared.deleteNotes(at: selectedNotesId)
            selectedNotesId.removeAll()
            tableView.reloadData()
            } else {
                showAlert()
                return
            }
            tableViewModel.isEditTable.toggle()
            switchMode(tableViewModel.isEditTable)
        }
    }

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

    private func configureRightBarButtonItem() {
        rightBarButtonItem.title = "Выбрать"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(rightBarButtonItemAction)
    }

    @objc func rightBarButtonItemAction() {
        tableViewModel.isEditTable.toggle()
//        tableViewModel.switchOffIsChosen()
        tableView.reloadData()
        switchMode(tableViewModel.isEditTable)
    }

    private func switchMode(_ isEdit: Bool) {
        animateSelection(isEdit)
        if isEdit {
            rightBarButtonItem.title = "Готово"
        } else {
            rightBarButtonItem.title = "Выбрать"
        }
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
//        let note = notes[indexPath.row]
//        cell.configureCell(from: note, isEdit: tableIsEdit)
        cell.configureCell(from: tableViewModel.getCurrentCellViewModel(indexPath))
        cell.backgroundColor = viewBackgroundColor
        return cell
    }

    func updateSelectedNotesId(indexPath: IndexPath) {
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
            let note = notes[indexPath.row]
            let noteVC = NoteViewController()
            noteVC.note = note
            noteVC.delegate = self
            navigationController?.pushViewController(noteVC, animated: true)
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
        ) {
            self.addKeyFrames()
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
            with: switchableButton,
            duration: 0.5,
            options: [.transitionFlipFromRight]) {
                if isEdit {
                    let noteButtonImage = UIImage(named: "deleteButton")
                    self.switchableButton.setImage(noteButtonImage, for: .normal)
                } else {
                    let noteButtonImage = UIImage(named: "button")
                    self.switchableButton.setImage(noteButtonImage, for: .normal)
                }
        }
    }
}
