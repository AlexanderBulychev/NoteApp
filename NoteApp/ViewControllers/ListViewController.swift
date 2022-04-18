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
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    private var createNewNoteButton = UIButton()

    private var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        title = "Заметки"
        navigationItem.backButtonTitle = ""

        setupUI()
        notes = StorageManager.shared.getNotes()
        display(notes)
    }

    private func setupUI() {
        configureScrollView()
        configureStackView()
        configureCreateNewNoteButton()
    }

    private func configureScrollView() {
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = scrollView.topAnchor.constraint(
            equalTo: view.topAnchor
        )
        let leadingConstraint = scrollView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor
        )
        let trailingConstraint = scrollView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor
        )
        let bottomConstraint = scrollView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     bottomConstraint])
    }

    private func configureStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = stackView.topAnchor.constraint(
            equalTo: scrollView.contentLayoutGuide.topAnchor
        )
        let leadingConstraint = stackView.leadingAnchor.constraint(
            equalTo: scrollView.contentLayoutGuide.leadingAnchor
        )
        let trailingConstraint = stackView.trailingAnchor.constraint(
            equalTo: scrollView.contentLayoutGuide.trailingAnchor
        )
        let bottomConstraint = stackView.bottomAnchor.constraint(
            equalTo: scrollView.contentLayoutGuide.bottomAnchor
        )
        let widthConstraint = stackView.widthAnchor.constraint(
            equalTo: scrollView.widthAnchor
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     bottomConstraint,
                                     widthConstraint
                                    ])
    }

    private func configureCreateNewNoteButton() {
        view.addSubview(createNewNoteButton)
        let noteButtonImage = UIImage(named: "button")
        createNewNoteButton.setImage(noteButtonImage, for: .normal)
        createNewNoteButton.layer.cornerRadius = 25
        createNewNoteButton.clipsToBounds = true

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
        notes.append(note)
        display(notes)
    }
}
