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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(from note: Note) {
        noteHeaderLabel.text = note.header
        noteBodyLabel.text = note.body
        noteDateLabel.text = formatDate(date: note.date)
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

        noteView.addSubview(noteHeaderLabel)
        noteHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        let topHeaderConstraint = noteHeaderLabel.topAnchor.constraint(
            equalTo: noteView.topAnchor, constant: 10
        )
        let leadingHeaderConstraint = noteHeaderLabel.leadingAnchor.constraint(
            equalTo: noteView.leadingAnchor, constant: 16
        )
        let trailingHeaderConstraint = noteHeaderLabel.trailingAnchor.constraint(
            equalTo: noteView.trailingAnchor, constant: -16
        )
        let heighHeaderConstraint = noteHeaderLabel.heightAnchor.constraint(
            equalToConstant: 18
        )
        NSLayoutConstraint.activate([topHeaderConstraint,
                                     leadingHeaderConstraint,
                                     trailingHeaderConstraint,
                                     heighHeaderConstraint
                                    ])

        noteView.addSubview(noteBodyLabel)
        noteBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        let topBodyConstraint = noteBodyLabel.topAnchor.constraint(
            equalTo: noteHeaderLabel.bottomAnchor, constant: 4
        )
        let leadingBodyConstraint = noteBodyLabel.leadingAnchor.constraint(
            equalTo: noteView.leadingAnchor, constant: 16
        )
        let trailingBodyConstraint = noteBodyLabel.trailingAnchor.constraint(
            equalTo: noteView.trailingAnchor, constant: -16
        )
        let heighBodyConstraint = noteBodyLabel.heightAnchor.constraint(
            equalToConstant: 14
        )
        NSLayoutConstraint.activate([topBodyConstraint,
                                     leadingBodyConstraint,
                                     trailingBodyConstraint,
                                     heighBodyConstraint
                                    ])

        noteView.addSubview(noteDateLabel)
        noteDateLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDateConstraint = noteDateLabel.topAnchor.constraint(
            equalTo: noteBodyLabel.bottomAnchor, constant: 24
        )
        let leadingDateConstraint = noteDateLabel.leadingAnchor.constraint(
            equalTo: noteView.leadingAnchor, constant: 16
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
