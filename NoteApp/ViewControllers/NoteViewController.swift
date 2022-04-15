//
//  ViewController.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import UIKit

class NoteViewController: UIViewController {
    var delegate: NoteViewControllerDelegateProtocol!

    private var dateLabel = UILabel()
    private var noteHeaderTextField = UITextField()
    private var noteBodyTextView = UITextView()

    private var readyBarButtonItem = UIBarButtonItem()
    private var backBarButtonItem = UIBarButtonItem()

    private var note: Note!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()

        noteBodyTextView.becomeFirstResponder()
        noteHeaderTextField.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let note = note else { return }
        StorageManager.shared.save(note: note)
        delegate.saveNote(note)
    }

    private func setupUI() {
        setupDateLabel()
        setupNoteHeaderTextField()
        setupNoteBodyTextView()
        setupBarButtonItem()
//        setupBackButtonItem()
    }

    private func setupDateLabel() {
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .lightGray

        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = dateLabel.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 12
        )
        let leadingConstraint = dateLabel.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 20
        )
        let trailingConstraint = dateLabel.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -20
        )
        let heightConstraint = dateLabel.heightAnchor.constraint(
            equalToConstant: 16
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     heightConstraint])
        dateLabel.text = formatDate(date: Date())
    }

    private func setupNoteHeaderTextField() {
        noteHeaderTextField.placeholder = "Введите название"
        noteHeaderTextField.font = .boldSystemFont(ofSize: 24)

        view.addSubview(noteHeaderTextField)
        noteHeaderTextField.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = noteHeaderTextField.topAnchor.constraint(
            equalTo: dateLabel.bottomAnchor,
            constant: 20
        )
        let leadingConstraint = noteHeaderTextField.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 20
        )
        let trailingConstraint = noteHeaderTextField.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -20
        )
        let heightConstraint = noteHeaderTextField.heightAnchor.constraint(
            equalToConstant: 24
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     heightConstraint])
    }

    private func setupNoteBodyTextView() {
        noteBodyTextView.font = .systemFont(ofSize: 16)

        view.addSubview(noteBodyTextView)
        noteBodyTextView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = noteBodyTextView.topAnchor.constraint(
            equalTo: noteHeaderTextField.bottomAnchor,
            constant: 28
        )
        let leadingConstraint = noteBodyTextView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 20
        )
        let trailingConstraint = noteBodyTextView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -20
        )
        let bottomConstraint = noteBodyTextView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: 145
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     bottomConstraint])
    }

    private func setupBarButtonItem() {
        readyBarButtonItem.title = "Готово"
        navigationItem.rightBarButtonItem = readyBarButtonItem
        readyBarButtonItem.target = self
        readyBarButtonItem.action = #selector(readyBarButtonAction)
    }

    @objc private func readyBarButtonAction() {
        view.endEditing(true)
        note = Note(
            header: noteHeaderTextField.text ?? "",
            body: noteBodyTextView.text ?? "",
            date: .now
        )
        checkIsEmpty(note: note)
    }
    private func setupBackButtonItem() {
        backBarButtonItem.title = "<"
        backBarButtonItem.style = .plain
        backBarButtonItem.target = self
        backBarButtonItem.action = #selector(leftBarButtonItemAction)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc func leftBarButtonItemAction() {
        guard let note = note else { return }
//        navigationController?.popToRootViewController(animated: true)
//        navigationController?.viewControllers.first
//        navigationController?.popViewController(animated: true)
//        navigationController?.topViewController(listVC)
//        navigationController?.popToViewController(listVC, animated: true)
        StorageManager.shared.save(note: note)
        delegate.saveNote(note)
    }
}

// MARK: - Preparing Date for label
extension NoteViewController {
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YYYY EEEE HH:MM"
        return formatter.string(from: date)
    }
}

// MARK: - UIText Field Delegate
extension NoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let newPosition = noteBodyTextView.endOfDocument
        noteBodyTextView.selectedTextRange = noteBodyTextView.textRange(from: newPosition, to: newPosition)
        return noteBodyTextView.becomeFirstResponder()
    }
}

// MARK: - Private methods
extension NoteViewController {
    private func showAlert() {
        let alert = UIAlertController(
            title: "Пустые поля",
            message: "Заполните название и текст заметки",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    private func checkIsEmpty(note: Note) {
        if note.isEmpty {
            showAlert()
            return
        }
    }
}
