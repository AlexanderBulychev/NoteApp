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
    private var dateField = UITextField()

    private var datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Новая заметка"

        setupBarButtonItem()
        setupNoteHeaderTextField()
        setupDateField()
        setupDatePicker()
        setupNoteBodyTextView()

        noteHeaderTextField.becomeFirstResponder()
        noteHeaderTextField.delegate = self

        guard let note = StorageManager.shared.getNote() else { return }
        noteHeaderTextField.text = note.header
        noteBodyTextView.text = note.body
        dateField.text = note.date
    }

    private func setupBarButtonItem() {
        readyBarButtonItem.title = "Готово"
        navigationItem.rightBarButtonItem = readyBarButtonItem
        readyBarButtonItem.target = self
        readyBarButtonItem.action = #selector(readyBarButtonAction)
    }

    @objc private func readyBarButtonAction() {
        view.endEditing(true)

        let note = Note(
            header: noteHeaderTextField.text,
            body: noteBodyTextView.text,
            date: dateField.text ?? ""
        )
        if !note.isEmpty {
            StorageManager.shared.saveNote(note: note)
            return
        }
        showAlert()
    }

    private func setupNoteHeaderTextField() {
        noteHeaderTextField.backgroundColor = .lightGray
        noteHeaderTextField.placeholder = "Введите заголовок заметки"
        noteHeaderTextField.font = .boldSystemFont(ofSize: 22)
        noteHeaderTextField.borderStyle = .roundedRect
        noteHeaderTextField.returnKeyType = .next

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
            equalTo: dateField.bottomAnchor,
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

    private func setupDateField() {
        dateField.borderStyle = .roundedRect
        dateField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(dateField)
        let topConstraint = dateField.topAnchor.constraint(
            equalTo: noteHeaderTextField.bottomAnchor,
            constant: 8
        )
        let leadingConstraint = dateField.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        )
        let trailingConstraint = dateField.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -16
        )
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint])

        dateField.inputView = datePicker
        dateField.placeholder = getDate()
        dateField.inputAccessoryView = setupToolbar()
    }
}

extension NewNoteViewController {
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
}

// MARK: - Getting Data from DatePicker
extension NewNoteViewController {
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
    }
    private func setupToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolbarDoneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([flexSpace, doneButton], animated: true)
        return toolbar
    }

    @objc func toolbarDoneAction() {
        dateField.text = getDate()
        view.endEditing(true)
        noteBodyTextView.becomeFirstResponder()
    }

    private func getDate() -> String {
        let dateText: String
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "Дата: dd MMMM YYYY"
        dateText = formatter.string(from: datePicker.date)
        return dateText
    }
}

extension NewNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateField.becomeFirstResponder()
    }
}
