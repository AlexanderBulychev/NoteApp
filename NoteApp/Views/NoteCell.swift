//
//  NoteTableViewCell.swift
//  NoteApp
//
//  Created by asbul on 19.04.2022.
//

import UIKit

final class NoteCell: UITableViewCell {
    var viewModel: Note? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            configureUI(viewModel)
        }
    }

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
        setupLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabels() {
        self.addSubview(noteHeaderLabel)
        noteHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        let topHeaderConstraint = noteHeaderLabel.topAnchor.constraint(
            equalTo: self.topAnchor, constant: 10
        )
        let leadingHeaderConstraint = noteHeaderLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: 16
        )
        let trailingHeaderConstraint = noteHeaderLabel.trailingAnchor.constraint(
            equalTo: self.trailingAnchor, constant: -16
        )
        let heighHeaderConstraint = noteHeaderLabel.heightAnchor.constraint(
            equalToConstant: 18
        )
        NSLayoutConstraint.activate([topHeaderConstraint,
                                     leadingHeaderConstraint,
                                     trailingHeaderConstraint,
                                     heighHeaderConstraint
                                    ])

        self.addSubview(noteBodyLabel)
        noteBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        let topBodyConstraint = noteBodyLabel.topAnchor.constraint(
            equalTo: noteHeaderLabel.bottomAnchor, constant: 4
        )
        let leadingBodyConstraint = noteBodyLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: 16
        )
        let trailingBodyConstraint = noteBodyLabel.trailingAnchor.constraint(
            equalTo: self.trailingAnchor, constant: -16
        )
        let heighBodyConstraint = noteBodyLabel.heightAnchor.constraint(
            equalToConstant: 14
        )
        NSLayoutConstraint.activate([topBodyConstraint,
                                     leadingBodyConstraint,
                                     trailingBodyConstraint,
                                     heighBodyConstraint
                                    ])

        self.addSubview(noteDateLabel)
        noteDateLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDateConstraint = noteDateLabel.topAnchor.constraint(
            equalTo: noteBodyLabel.bottomAnchor, constant: 24
        )
        let leadingDateConstraint = noteDateLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: 16
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

    private func configureUI(_ viewModel: Note) {
        noteHeaderLabel.text = viewModel.header
        noteBodyLabel.text = viewModel.body
        noteDateLabel.text = formatDate(date: viewModel.date)
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
