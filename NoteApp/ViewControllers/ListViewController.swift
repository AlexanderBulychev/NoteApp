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
    private var createNewNoteButtonBottomConstraint: NSLayoutConstraint!
    private var createNewNoteButtonTrailingConstraint: NSLayoutConstraint!

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

//        UIView.transition(
//            with: createNewNoteButton,
//            duration: 3,
//            options: [.transitionFlipFromRight, .repeat, .autoreverse]) {
//                let noteButtonImage = UIImage(named: "deleteButton")
//                self.createNewNoteButton.setImage(noteButtonImage, for: .normal)
//        }

//        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
//        animation.fromValue = createNewNoteButton.layer.bounds.origin
//        animation.toValue = createNewNoteButton.layer.bounds.offsetBy(dx: -5, dy: -5)
//        animation.duration = 2
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        createNewNoteButton.layer.add(animation, forKey: nil)
    }

    private func animatePushing() {
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.fromValue = [0, 0]
//        animation.toValue = [300, 300]
//        animation.duration = 3
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        createNewNoteButton.layer.add(animation, forKey: nil)
//
//        let animationOp = CABasicAnimation(keyPath: "opacity")
//        animationOp.fromValue = 1
//        animationOp.toValue = 0
//        animationOp.duration = 3
//        animationOp.beginTime = CACurrentMediaTime() + 3
//        animationOp.fillMode = .forwards
//        animationOp.isRemovedOnCompletion = false
//        animation.
//        createNewNoteButton.layer.add(animationOp, forKey: nil)

        UIView.animateKeyframes(
            withDuration: 10,
            delay: 0,
            options: [.repeat],
            animations: {
                self.addKeyFrames()
            }
//            completion: { _ in
//                let noteVC = NoteViewController()
//                noteVC.delegate = self
//                self.navigationController?.pushViewController(noteVC, animated: true)
//            }
        )
    }

    private func addKeyFrames() {
        UIView.addKeyframe(
            withRelativeStartTime: 2,
            relativeDuration: 0.25) {
                self.createNewNoteButtonBottomConstraint.constant -= 10
        }
        UIView.addKeyframe(
            withRelativeStartTime: 0.25,
            relativeDuration: 0.75) {
                self.createNewNoteButtonBottomConstraint.constant += 120
        }
    }

    private func setupUI() {
        configureTableView()
        configureCreateNewNoteButton()
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
//        let noteVC = NoteViewController()
//        noteVC.delegate = self
//        navigationController?.pushViewController(noteVC, animated: true)
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
}

extension ListViewController: NoteViewControllerDelegateProtocol {
    func addNote(_ note: Note, _ isEditing: Bool) {
        if !isEditing {
            notes.append(note)
        }
        tableView.reloadData()
    }
}
