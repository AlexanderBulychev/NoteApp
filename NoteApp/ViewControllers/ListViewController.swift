//
//  ListViewController.swift
//  NoteApp
//
//  Created by asbul on 11.04.2022.
//

import UIKit

protocol NoteViewControllerDelegateProtocol: AnyObject {
    func saveNote(_ note: Note, _ isEditing: Bool)
}

class ListViewController: UIViewController {
    var tableView = UITableView()
    var notes: [Note] = []

    struct Cells {
        static let noteCell = "NoteCell"
    }

    private let viewBackgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    private var stackView = UIStackView()
    private var createNewNoteButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        title = "Заметки"
        navigationItem.backButtonTitle = ""

        setupUI()
        notes = StorageManager.shared.getNotes()
    }

    private func setupUI() {
        configureTableView()
        configureCreateNewNoteButton()
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.register(NoteCell.self, forCellReuseIdentifier: Cells.noteCell)
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
        let leadingConstraint = tableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor
        )
        let trailingConstraint = tableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor
        )
        let bottomConstraint = tableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     bottomConstraint])
    }

    private func configureCreateNewNoteButton() {
        view.addSubview(createNewNoteButton)
        let noteButtonImage = UIImage(named: "button")
        createNewNoteButton.setImage(noteButtonImage, for: .normal)

        createNewNoteButton.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = createNewNoteButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -19
        )
        let bottomConstraint = createNewNoteButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: -60
        )
        NSLayoutConstraint.activate([trailingConstraint,
                                     bottomConstraint
                                    ])
        createNewNoteButton.addTarget(self, action: #selector(createNewNoteButtonPressed), for: .touchUpInside)
    }

    @objc func createNewNoteButtonPressed() {
        let noteVC = NoteViewController()
        noteVC.delegate = self
        navigationController?.pushViewController(noteVC, animated: true)
    }

    private func display(_ note: [Note]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        note.forEach { note in
            let noteView = NoteView()
            noteView.viewModel = note

            noteView.tapCompletion = { [weak self] note in
                let noteVC = NoteViewController()
                noteVC.note = note
                noteVC.delegate = self

                self?.navigationController?.pushViewController(noteVC, animated: true)
            }
            stackView.addArrangedSubview(noteView)
        }
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Cells.noteCell,
            for: indexPath
        ) as? NoteCell else { return UITableViewCell() }

        let note = notes[indexPath.row]
        cell.viewModel = note
        cell.backgroundColor = viewBackgroundColor

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let noteVC = NoteViewController()
        noteVC.note = note
        noteVC.delegate = self

        navigationController?.pushViewController(noteVC, animated: true)
    }
}

extension ListViewController: NoteViewControllerDelegateProtocol {
    func saveNote(_ note: Note, _ isEditing: Bool) {
        if !isEditing {
            notes.append(note)
            tableView.reloadData()
            return
        }
        tableView.reloadData()
    }
}
