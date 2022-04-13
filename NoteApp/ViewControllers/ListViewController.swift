//
//  ListViewController.swift
//  NoteApp
//
//  Created by asbul on 11.04.2022.
//

import UIKit

protocol NoteViewControllerDelegateProtocol {
    func saveNote(_ note: Note)
}

class ListViewController: UIViewController {
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    private var createNewNoteButton = UIButton()

    private var notes: [Note] = [.init(header: "1", body: "1", date: .now),
                                 .init(header: "2", body: "2", date: .now),
                                 .init(header: "3", body: "3", date: .now),
                                 .init(header: "4", body: "4", date: .now),
                                 .init(header: "5", body: "5", date: .now)]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        title = "Заметки"

        setupUI()
        display(notes)
    }

    private func setupUI() {
        configureScrollView()
        configureStackView()
        configureCreateNewNoteButton()
    }

    private func configureScrollView() {
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
        stackView.backgroundColor = .yellow

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
        createNewNoteButton.addTarget(self, action: #selector(didTapCreateNewNoteButton), for: .touchUpInside)
    }

    @objc func didTapCreateNewNoteButton() {
        let noteVC = NoteViewController()
        navigationController?.pushViewController(noteVC, animated: true)
    }

    private func display(_ note: [Note]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        note.forEach { note in
            let noteView = NoteView()
            noteView.viewModel = note
            stackView.addArrangedSubview(noteView)

            // noteView.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
            noteView.action = {
                print("hello")
            }
        }
    }
}

extension ListViewController: NoteViewControllerDelegateProtocol {
    func saveNote(_ note: Note) {
        notes.append(note)
    }
}
