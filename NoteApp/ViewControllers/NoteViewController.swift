//
//  ViewController.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import UIKit

class NoteViewController: UIViewController {
    weak var delegate: NoteViewControllerDelegateProtocol?
    var note: Note?
    var isEditingNote: Bool = false

    private var bottomConstraint: NSLayoutConstraint!
    private var dateLabel = UILabel()
    private var noteHeaderTextField = UITextField()
    private var noteBodyTextView = UITextView()

    private var readyBarButtonItem = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        noteBodyTextView.becomeFirstResponder()
        noteBodyTextView.delegate = self

        isEditingNote = (note != nil) ? true : false

        noteHeaderTextField.text = note?.header
        noteBodyTextView.text = note?.body
        dateLabel.text = formatDate(date: note?.date)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isEditingNote {
            note?.header = noteHeaderTextField.text ?? ""
            note?.body = noteBodyTextView.text ?? ""
            note?.date = .now
        } else {
            note = Note(
                header: noteHeaderTextField.text ?? "",
                body: noteBodyTextView.text ?? "",
                date: .now
            )
        }
        guard let note = note,
        !note.isEmpty else {
            return
        }
        StorageManager.shared.save(note: note)
        delegate?.addNote(note, isEditingNote)
    }

    private func setupUI() {
        setupDateLabel()
        setupNoteHeaderTextField()
        setupNoteBodyTextView()
        setupBarButtonItem()
        registerForKeyboardNotifications()
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
            equalTo: noteHeaderTextField.topAnchor,
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
        bottomConstraint = noteBodyTextView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -145
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

        if isEditingNote {
            note?.header = noteHeaderTextField.text ?? ""
            note?.body = noteBodyTextView.text ?? ""
            note?.date = .now
        } else {
            note = Note(
                header: noteHeaderTextField.text ?? "",
                body: noteBodyTextView.text ?? "",
                date: .now
            )
        }
        guard let note = note,
              !note.isEmpty else {
                  showAlert()
                  return
              }
    }
}

// MARK: - Preparing Date for label
extension NoteViewController {
    private func formatDate(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YYYY EEEE HH:mm"
        return formatter.string(from: date)
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

//    private func checkIsEmpty(note: Note) {
//        if note.isEmpty {
//            showAlert(with: "Пустые поля", message: "Заполните название и текст заметки")
//            return
//        }
//    }
}

// MARK: - UITextView Delegate
extension NoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = noteBodyTextView.endOfDocument
        noteBodyTextView.selectedTextRange = noteBodyTextView.textRange(from: newPosition, to: newPosition)
    }
}

// MARK: - Configure keyboard Notifications
extension NoteViewController {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatenoteBodyTextView(notification: )),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatenoteBodyTextView(notification: )),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func updatenoteBodyTextView(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            if notification.name == UIResponder.keyboardWillHideNotification {
                noteBodyTextView.contentInset = UIEdgeInsets.zero
                readyBarButtonItem.isEnabled = false
            } else {
                noteBodyTextView.contentInset = UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: keyboardHeight + (bottomConstraint.constant + 10),
                    right: 0
                )
                readyBarButtonItem.isEnabled = true
                noteBodyTextView.scrollIndicatorInsets = noteBodyTextView.contentInset
            }
            noteBodyTextView.scrollRangeToVisible(noteBodyTextView.selectedRange)
        }
    }
}
