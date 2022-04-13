//
//  NoteView.swift
//  NoteApp
//
//  Created by asbul on 12.04.2022.
//

import UIKit

final class NoteView: UIView {
    var action: (() -> Void)?
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
        noteHeaderLabel.frame.size = CGSize(width: 326, height: 18)
        noteHeaderLabel.font = UIFont(name: "SFProText-Medium", size: 16)
        noteHeaderLabel.text = "aassdddddd"
        return noteHeaderLabel
    }()

    private let noteBodyLabel: UILabel = {
        let noteBodyLabel = UILabel()
        noteBodyLabel.frame.size = CGSize(width: 326, height: 14)
        noteBodyLabel.font = UIFont(name: "SFProText-Medium", size: 10)
        noteBodyLabel.textColor = UIColor(red: 172, green: 172, blue: 172, alpha: 1)
        noteBodyLabel.text = "sdffffdffdfd"
        return noteBodyLabel
    }()

    private let noteDateLabel: UILabel = {
        let noteDateLabel = UILabel()
        noteDateLabel.frame.size = CGSize(width: 68, height: 10)
        noteDateLabel.font = UIFont(name: "SFProText-Medium", size: 10)
        noteDateLabel.text = "assdddsds"
        return noteDateLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 14

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 358),
            self.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    // What does this method mean?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(_ viewModel: Note) {
        action?()
    }
}
