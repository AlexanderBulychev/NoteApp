//
//  NoteTableViewCell.swift
//  NoteApp
//
//  Created by asbul on 19.04.2022.
//

import UIKit

final class NoteCell: UITableViewCell {
    private let noteView: UIView = {
        let noteViewCell = UIView()
        noteViewCell.backgroundColor = .white
        noteViewCell.layer.cornerRadius = 14
        return noteViewCell
    }()

    private let noteHeaderLabel: UILabel = {
        let noteHeaderLabel = UILabel()
        noteHeaderLabel.font = .systemFont(ofSize: 16)
        return noteHeaderLabel
    }()

    private let noteBodyLabel: UILabel = {
        let noteBodyLabel = UILabel()
        noteBodyLabel.font = .systemFont(ofSize: 10)
        noteBodyLabel.textColor = .lightGray
        return noteBodyLabel
    }()

    private let noteDateLabel: UILabel = {
        let noteDateLabel = UILabel()
        noteDateLabel.font = .systemFont(ofSize: 10)
        return noteDateLabel
    }()

    private let labelsView: UIView = {
        let labelsView = UIView()
        labelsView.backgroundColor = .systemPink
        return labelsView
    }()
    private var leadingLabelsViewConstraint: NSLayoutConstraint!

    private lazy var checkmarkButton: UIButton = {
        let checkmarkButton = UIButton()
        let checkmarkEmptyImage = UIImage(named: "checkmarkEmpty")
        checkmarkButton.setImage(checkmarkEmptyImage, for: .normal)
        checkmarkButton.addTarget(self, action: #selector(checkmarkButtonAction), for: .touchUpInside)
        return checkmarkButton
    }()
    private var leadingCheckMarkButtonConstraint: NSLayoutConstraint!

    var isEdit: Bool = false {
        didSet {
            animateCellContent()
            checkmarkButton.isHidden = !isEdit
        }
    }

    var didTap: ((String) -> Void)?

    @objc func checkmarkButtonAction() {
        didTap?(noteId)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print(#function)
    }

    private var noteId: String = ""

    func configureCell(from note: Note) {
        noteHeaderLabel.text = note.header
        noteBodyLabel.text = note.body
        noteDateLabel.text = formatDate(date: note.date)
        noteId = note.id
    }

    private func animateCellContent() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: []) {
                print("ER")

                if self.isEdit {
                    self.leadingLabelsViewConstraint.constant += 44
                    self.leadingCheckMarkButtonConstraint.constant += 56
                } else {
                    self.leadingLabelsViewConstraint.constant = 16
                    self.leadingCheckMarkButtonConstraint.constant = 16
                }
                self.layoutIfNeeded()
        }
    }

    private func setupUI() {
        addSubview(noteView)
        noteView.translatesAutoresizingMaskIntoConstraints = false
        let topViewConstraint = noteView.topAnchor.constraint(
            equalTo: self.topAnchor
        )
        let leadingViewConstraint = noteView.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: 16
        )
        let trailingViewConstraint = noteView.trailingAnchor.constraint(
            equalTo: self.trailingAnchor, constant: -16
        )
        let bottomViewConstraint = noteView.bottomAnchor.constraint(
            equalTo: self.bottomAnchor, constant: -4
        )
        NSLayoutConstraint.activate([topViewConstraint,
                                     leadingViewConstraint,
                                     trailingViewConstraint,
                                     bottomViewConstraint
                                    ])

        noteView.addSubview(labelsView)
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        let topLabelsViewConstraint = labelsView.topAnchor.constraint(
            equalTo: noteView.topAnchor, constant: 10
        )
        leadingLabelsViewConstraint = labelsView.leadingAnchor.constraint(
            equalTo: noteView.leadingAnchor, constant: 16
        )
        let trailingLabelsViewConstraint = labelsView.trailingAnchor.constraint(
            equalTo: noteView.trailingAnchor, constant: -16
        )
        let bottomLabelsViewConstraint = labelsView.bottomAnchor.constraint(
            equalTo: noteView.bottomAnchor, constant: -10
        )
        NSLayoutConstraint.activate([topLabelsViewConstraint,
                                     leadingLabelsViewConstraint,
                                     trailingLabelsViewConstraint,
                                     bottomLabelsViewConstraint])

        configureLabels()
        configureCheckMarkButton()
    }

    private func configureLabels() {
        labelsView.addSubview(noteHeaderLabel)
        noteHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        let topHeaderConstraint = noteHeaderLabel.topAnchor.constraint(
            equalTo: labelsView.topAnchor
        )
        let leadingHeaderConstraint = noteHeaderLabel.leadingAnchor.constraint(
            equalTo: labelsView.leadingAnchor
        )
        let trailingHeaderConstraint = noteHeaderLabel.trailingAnchor.constraint(
            equalTo: labelsView.trailingAnchor
        )
        let heighHeaderConstraint = noteHeaderLabel.heightAnchor.constraint(
            equalToConstant: 18
        )
        NSLayoutConstraint.activate([topHeaderConstraint,
                                     leadingHeaderConstraint,
                                     trailingHeaderConstraint,
                                     heighHeaderConstraint
                                    ])

        labelsView.addSubview(noteBodyLabel)
        noteBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        let topBodyConstraint = noteBodyLabel.topAnchor.constraint(
            equalTo: noteHeaderLabel.bottomAnchor, constant: 4
        )
        let leadingBodyConstraint = noteBodyLabel.leadingAnchor.constraint(
            equalTo: labelsView.leadingAnchor
        )
        let trailingBodyConstraint = noteBodyLabel.trailingAnchor.constraint(
            equalTo: labelsView.trailingAnchor
        )
        let heighBodyConstraint = noteBodyLabel.heightAnchor.constraint(
            equalToConstant: 14
        )
        NSLayoutConstraint.activate([topBodyConstraint,
                                     leadingBodyConstraint,
                                     trailingBodyConstraint,
                                     heighBodyConstraint
                                    ])

        labelsView.addSubview(noteDateLabel)
        noteDateLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDateConstraint = noteDateLabel.topAnchor.constraint(
            equalTo: noteBodyLabel.bottomAnchor, constant: 24
        )
        let leadingDateConstraint = noteDateLabel.leadingAnchor.constraint(
            equalTo: labelsView.leadingAnchor
        )
        let widthDateConstraint = noteDateLabel.widthAnchor.constraint(
            equalToConstant: 68
        )
        let heighDateConstraint = noteDateLabel.heightAnchor.constraint(
            equalToConstant: 10
        )
        NSLayoutConstraint.activate([topDateConstraint,
                                     leadingDateConstraint,
                                     widthDateConstraint,
                                     heighDateConstraint
                                    ])
    }

    private func configureCheckMarkButton() {
        noteView.addSubview(checkmarkButton)
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        let topButtonConstraint = checkmarkButton.topAnchor.constraint(
            equalTo: noteView.topAnchor, constant: 37
        )
        leadingCheckMarkButtonConstraint = checkmarkButton.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: -16
        )
        NSLayoutConstraint.activate([topButtonConstraint,
                                     leadingCheckMarkButtonConstraint])
    }
}

// MARK: - Preparing Date for label
extension NoteCell {
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YYYY"
        return formatter.string(from: date)
    }
}
