//
//  ViewController.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import UIKit

class NewNoteViewController: UIViewController {
    private var readyBarButtonItem = UIBarButtonItem()
    private var noteHeaderTextField = UITextField()
    private var noteBodyTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Новая заметка"

        setupBarButtonItem()
        setupNoteHeaderTextField()
        setupNoteBodyTextView()

        noteBodyTextView.becomeFirstResponder()

        guard let note = StorageManager.shared.getNote() else { return }
        noteHeaderTextField.text = note.header
        noteBodyTextView.text = note.body
    }

    private func setupBarButtonItem() {
        readyBarButtonItem.title = "Готово"
        navigationItem.rightBarButtonItem = readyBarButtonItem
        readyBarButtonItem.target = self
        readyBarButtonItem.action = #selector(readyBarButtonAction)
    }

    @objc private func readyBarButtonAction() {
        view.endEditing(true)

        guard let headerText = noteHeaderTextField.text,
              let noteText = noteBodyTextView.text
        else { return }
        let note = Note(header: headerText, body: noteText)
        StorageManager.shared.saveNote(note: note)
    }

    private func setupNoteHeaderTextField() {
        noteHeaderTextField.backgroundColor = .lightGray
        noteHeaderTextField.placeholder = "Введите заголовок заметки"
        noteHeaderTextField.font = .boldSystemFont(ofSize: 22)
        noteHeaderTextField.borderStyle = .roundedRect

        noteHeaderTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteHeaderTextField)
        let topConstraint = noteHeaderTextField.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 16
        )
        let leadingConstraint = noteHeaderTextField.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        )
        let trailingConstraint = noteHeaderTextField.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -16
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint])
    }

    private func setupNoteBodyTextView() {
        noteBodyTextView.backgroundColor = .black.withAlphaComponent(0.1)
        noteBodyTextView.text = "Добавьте текст заметки здесь"
        noteBodyTextView.font = .systemFont(ofSize: 14)
        noteBodyTextView.layer.cornerRadius = 8

        noteBodyTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteBodyTextView)
        let topConstraint = noteBodyTextView.topAnchor.constraint(
            equalTo: noteHeaderTextField.bottomAnchor,
            constant: 8
        )
        let leadingConstraint = noteBodyTextView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        )
        let trailingConstraint = noteBodyTextView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -16
        )
        let bottomConstraint = noteBodyTextView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     bottomConstraint])
    }
}
