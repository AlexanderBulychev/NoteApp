//
//  ViewController.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import UIKit

class NoteViewController: UIViewController {
    private var dateLabel = UILabel()
    private var noteHeaderTextField = UITextField()
    private var noteBodyTextView = UITextView()

    private var readyBarButtonItem = UIBarButtonItem()
    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: .init(named: "back"),
            style: .plain,
            target: self,
            action: #selector(someFunc)
        )
        return button
    }()

    private var delegate: NoteViewControllerDelegateProtocol!
    private var note: Note!

//    var closure: ((Note, String?, Int?) -> Void)?
//    func saveAction() {
//        let note = Note(header: "1", body: "", date: nil)
//        closure?(note, nil, 5)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(self.navigationItem)

        setupUI()

        noteBodyTextView.becomeFirstResponder()
        noteHeaderTextField.delegate = self

        // get out from this controller
//        guard let note = StorageManager.shared.getNote() else { return }
//        noteHeaderTextField.text = note.header
//        noteBodyTextView.text = note.body
//        if let date = note.date {
//            dateLabel.text = formatDate(date: date)
//            return
//        }
//        dateLabel.text = formatDate(date: Date())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }

    private func setupUI() {
        setupDateLabel()
        setupNoteHeaderTextField()
        setupNoteBodyTextView()
        setupBackButtonItem()
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
//        backBarButton.title = "1223"
//        backBarButton.target = self
//        backBarButton.action = #selector(someFunc)
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
//        self.navigationController?.navigationBar.backItem?.backBarButtonItem = backBarButton
        navigationItem.leftBarButtonItem = backBarButton

//        let button = self.navigationController?.navigationBar.backItem?.backBarButtonItem
//        button?.target = self
//        button?.action = #selector(someFunc)
    }

    @objc func someFunc() {
        print("Ok")
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
