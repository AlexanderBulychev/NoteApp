//
//  ViewController.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import UIKit

class NoteViewController: UIViewController {
    private var readyBarButtonItem = UIBarButtonItem()
    private var noteHeaderTextField = UITextField()
    private var noteBodyTextView = UITextView()
    private var dateField = UITextField()

    private var datePicker = UIDatePicker()

    private var delegate: NoteViewControllerDelegateProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Новая заметка"

        setupUI()

        noteHeaderTextField.becomeFirstResponder()
        noteHeaderTextField.delegate = self

        guard let note = StorageManager.shared.getNote() else { return }
        noteHeaderTextField.text = note.header
        noteBodyTextView.text = note.body
        if let date = note.date {
            dateField.text = formatDate(date: date)
            return
        }
        dateField.text = ""
    }

    private func setupUI() {
        setupBarButtonItem()
        setupNoteHeaderTextField()
        setupDateField()
        setupDatePicker()
        setupNoteBodyTextView()
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
            header: noteHeaderTextField.text ?? "",
            body: noteBodyTextView.text ?? "",
            date: getDateToStore()
        )
        checkIsEmpty(note: note)
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
//        noteBodyTextView.text = "Добавьте текст заметки здесь"
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
        dateField.clearButtonMode = .always
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
        dateField.placeholder = formatDate(date: Date())
    }
}

// MARK: - Getting Data from DatePicker
extension NoteViewController {
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector (dateChange(datePicker: )), for: UIControl.Event.valueChanged)
    }

    @objc func dateChange(datePicker: UIDatePicker) {
        dateField.text = formatDate(date: datePicker.date)
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "Дата: dd MMMM YYYY"
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

    private func getDateToStore() -> Date? {
        var dateToStore: Date?
        guard dateField.text != "" else { return nil }
        dateToStore = datePicker.date
        return dateToStore
    }

    private func checkIsEmpty(note: Note) {
        if note.isEmpty {
            showAlert()
            return
        }
        StorageManager.shared.saveNote(note: note)
    }
}
