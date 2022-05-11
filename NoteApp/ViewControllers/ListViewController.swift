//
//  ListViewController.swift
//  NoteApp
//
//  Created by asbul on 11.04.2022.
//

import UIKit

protocol NoteViewControllerDelegateProtocol: AnyObject {
    func addNote(_ note: Note, _ isEditing: Bool)
}

class ListViewController: UIViewController {
    var tableView = UITableView()
    var notes: [Note] = []

    private let noteCellName = "NoteCell"
    private let viewBackgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    private var createNewNoteButton = UIButton()
    private var rightBarButtonItem = UIBarButtonItem()

    private var createNewNoteButtonBottomConstraint: NSLayoutConstraint!
    private var createNewNoteButtonTrailingConstraint: NSLayoutConstraint!

    private var isEditingStyle: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        title = "Заметки"
        navigationItem.backButtonTitle = ""

        setupUI()
        notes = StorageManager.shared.getNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createNewNoteButtonTrailingConstraint.constant += 70
        createNewNoteButtonBottomConstraint.constant += 110
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAppearance()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        createNewNoteButtonBottomConstraint.constant -= 110
    }

    private func animateAppearance() {
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: []) { [ weak self ] in
                self?.createNewNoteButtonTrailingConstraint.constant -= 70
                self?.createNewNoteButtonBottomConstraint.constant -= 110
                self?.view.layoutIfNeeded()
        }
    }

    private func animatePushing() {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: []
        ) {
            self.addKeyFrames()
        } completion: { _ in
            let noteVC = NoteViewController()
            noteVC.delegate = self
            self.navigationController?.pushViewController(noteVC, animated: true)
        }
    }

    private func addKeyFrames() {
        UIView.addKeyframe(
            withRelativeStartTime: 0,
            relativeDuration: 0.5) { [ weak self ] in
                self?.createNewNoteButtonBottomConstraint.constant -= 10
                self?.view.layoutIfNeeded()
        }
        UIView.addKeyframe(
            withRelativeStartTime: 0.25,
            relativeDuration: 0.5) { [ weak self ] in
                self?.createNewNoteButtonBottomConstraint.constant += 120
                self?.view.layoutIfNeeded()
        }
    }

    private func animateSelection() {
        UIView.transition(
            with: createNewNoteButton,
            duration: 0.5,
            options: [.transitionFlipFromRight]) {
                let noteButtonImage = UIImage(named: "deleteButton")
                self.createNewNoteButton.setImage(noteButtonImage, for: .normal)
        }
    }

    private func setupUI() {
        configureTableView()
        configureCreateNewNoteButton()
        configureRightBarButtonItem()
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.register(NoteCell.self, forCellReuseIdentifier: noteCellName)
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
//        let leadingConstraint = tableView.leadingAnchor.constraint(
//            equalTo: view.leadingAnchor
//        )
        let trailingConstraint = tableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor
        )
        let bottomConstraint = tableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )
        NSLayoutConstraint.activate([topConstraint,
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     trailingConstraint,
                                     bottomConstraint])
    }

    private func configureCreateNewNoteButton() {
        view.addSubview(createNewNoteButton)
        let noteButtonImage = UIImage(named: "button")
        createNewNoteButton.setImage(noteButtonImage, for: .normal)

        createNewNoteButton.translatesAutoresizingMaskIntoConstraints = false
        createNewNoteButtonTrailingConstraint = createNewNoteButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20
        )
        createNewNoteButtonBottomConstraint = createNewNoteButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: -60
        )
        NSLayoutConstraint.activate([createNewNoteButtonTrailingConstraint,
                                     createNewNoteButtonBottomConstraint])
        createNewNoteButton.addTarget(self, action: #selector(createNewNoteButtonPressed), for: .touchUpInside)
    }

    @objc func createNewNoteButtonPressed() {
        animatePushing()
    }

    private func configureRightBarButtonItem() {
        rightBarButtonItem.title = "Выбрать"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(rightBarButtonItemAction)
    }

    @objc func rightBarButtonItemAction() {
        rightBarButtonItem.title = "Готово"
        animateSelection()
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: noteCellName,
            for: indexPath
        ) as? NoteCell else { return UITableViewCell() }

        let note = notes[indexPath.row]
        cell.configureCell(from: note)
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

//    func tableView(
//        _ tableView: UITableView,
//        editingStyleForRowAt indexPath: IndexPath
//    ) -> UITableViewCell.EditingStyle {
//        return .delete
//    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            print("Hu")
        } else {
            print("Uh")
        }
    }
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let choice = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [choice])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(
            style: .normal,
            title: "") { _, _, completion in
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
        }
        action.image = UIImage(named: "checkmarkEmpty")
        return action
    }
}

extension ListViewController: NoteViewControllerDelegateProtocol {
    func addNote(_ note: Note, _ isEditing: Bool) {
        if !isEditing {
            notes.append(note)
        }
        tableView.reloadData()
    }
}
