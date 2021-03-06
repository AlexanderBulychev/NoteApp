import UIKit

protocol NoteCellViewModelProtocol {
    var header: String { get }
    var text: String { get }
    var date: String { get }
    var userShareIcon: String? { get }

    var isEdited: Bool { get set }
    var isChosen: Bool { get set }
}

final class NoteCell: UITableViewCell {
    // MARK: - UI Elements
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
        return labelsView
    }()

    private var noteIconImageView: NoteIconImageView? = {
        let noteIcon = NoteIconImageView()
        noteIcon.frame.size = CGSize(width: 24, height: 24)
        noteIcon.layer.cornerRadius = noteIcon.frame.width / 2
        return noteIcon
    }()

    private var checkmarkImageView: UIImageView = {
        var checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(named: "checkmarkEmpty")
        return checkmarkImageView
    }()

    // MARK: - Supporting Properties
    private var leadingLabelsViewConstraint: NSLayoutConstraint!
    private var leadingCheckMarkButtonConstraint: NSLayoutConstraint!

    var isEdited: Bool = false
    var isChosen: Bool = false
    private var isShifted: Bool {
        leadingLabelsViewConstraint.constant > 16
    }

    // MARK: - Object lifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()

        print("created NoteCell class")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("deallocated NoteCell class")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        noteIconImageView?.image = nil
        noteIconImageView?.image = UIImage()
    }

    // MARK: - Configure UI Methods
    private func setupUI() {
        configureNoteView()
        configureLabelsView()
        configureNoteHeaderLabel()
        configureNoteBodyLabel()
        configureNoteDateLabel()
        configureCheckMarkButton()
        configureNoteIcon()
    }

    private func configureLabelsView() {
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
    }

    private func configureNoteView() {
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
    }

    private func configureNoteHeaderLabel() {
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
    }

    private func configureNoteBodyLabel() {
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
    }

    private func configureNoteDateLabel() {
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
        noteView.addSubview(checkmarkImageView)
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        let topButtonConstraint = checkmarkImageView.topAnchor.constraint(
            equalTo: noteView.topAnchor, constant: 37
        )
        leadingCheckMarkButtonConstraint = checkmarkImageView.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: -16
        )
        NSLayoutConstraint.activate([topButtonConstraint,
                                     leadingCheckMarkButtonConstraint])
    }

    private func configureNoteIcon() {
        guard let noteIconImageView = noteIconImageView else { return }
        noteView.addSubview(noteIconImageView)
        noteIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteIconImageView.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -16),
            noteIconImageView.bottomAnchor.constraint(equalTo: noteView.bottomAnchor, constant: -10),
            noteIconImageView.widthAnchor.constraint(equalToConstant: 24),
            noteIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // MARK: - Private methods
    private func changeCheckmarkImage(_ isChosen: Bool) {
        if isChosen {
            checkmarkImageView.image = UIImage(named: "checkmarkFilled")
        } else {
            checkmarkImageView.image = UIImage(named: "checkmarkEmpty")
        }
    }
}

// MARK: - Animation Methods
extension NoteCell {
    private func animateCellContent() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: []) {
                self.leadingLabelsViewConstraint.constant += 44
                self.leadingCheckMarkButtonConstraint.constant += 56
                self.layoutIfNeeded()
            }
    }

    private func animateCellContentBack() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: []) {
                self.leadingLabelsViewConstraint.constant -= 44
                self.leadingCheckMarkButtonConstraint.constant -= 56
                self.layoutIfNeeded()
            }
    }
}

// MARK: - NoteCell display logic
extension NoteCell {
    func configure(from viewModel: NoteCellViewModelProtocol) {
        noteHeaderLabel.text = viewModel.header
        noteBodyLabel.text = viewModel.text
        noteDateLabel.text = viewModel.date
        noteIconImageView?.set(from: viewModel.userShareIcon)
        isEdited = viewModel.isEdited
        isChosen = viewModel.isChosen
        
        if isEdited && !isShifted {
            animateCellContent()
        } else if !isEdited && isShifted {
            animateCellContentBack()
        }
        changeCheckmarkImage(isChosen)
    }
}
