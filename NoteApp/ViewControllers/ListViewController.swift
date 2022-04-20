//
//  ListViewController.swift
//  NoteApp
//
//  Created by asbul on 11.04.2022.
//

import UIKit

protocol NoteViewControllerDelegateProtocol: AnyObject {
    func saveNote(_ note: Note)
}

class ListViewController: UIViewController {
    var tableView = UITableView()

    var notes: [Note] = []

    private var stackView = UIStackView()
    private var createNewNoteButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        title = "Заметки"
        navigationItem.backButtonTitle = ""

        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.dataSource = self
        tableView.delegate = self

        setupUI()
        notes = StorageManager.shared.getNotes()
//        display(notes)
    }

    private func setupUI() {
        configureTableView()
        configureCreateNewNoteButton()
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.alpha = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = tableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 16
        )
        let leadingConstraint = tableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16
        )
        let trailingConstraint = tableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -16
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

extension ListViewController: NoteViewControllerDelegateProtocol {
    func saveNote(_ note: Note) {
        if !notes.contains(note) {
            StorageManager.shared.save(note: note)
            notes.append(note)
            display(notes)
            return
        }
        display(notes)
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NoteCell",
            for: indexPath
        ) as? NoteTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .green
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
