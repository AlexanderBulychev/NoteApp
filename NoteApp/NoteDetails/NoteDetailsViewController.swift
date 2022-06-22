import UIKit

protocol NoteDetailsDisplayLogic: AnyObject {
    func displayNoteDetails(viewModel: NoteDetails.ViewModel.ViewModelData)
}

final class NoteDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    private var noteHeaderTextField = UITextField()
    private var noteBodyTextView = UITextView()
    private var dateLabel = UILabel()
    
    private var readyBarButtonItem = UIBarButtonItem()
    
    private var bottomConstraint: NSLayoutConstraint!
    
    var interactor: NoteDetailsBusinessLogic?
    var router: (NSObjectProtocol & NoteDetailsRoutingLogic & NoteDetailsDataPassing)?
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("class NoteVC has been created")
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        print("class NoteVC has been deallocated")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        noteBodyTextView.becomeFirstResponder()
        noteBodyTextView.delegate = self
        
        passRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.provideNoteDetails(request: .saveNoteForPassing(
            noteHeader: noteHeaderTextField.text ?? "",
            noteText: noteBodyTextView.text ?? "",
            noteDate: .now
        ))
        router?.routeToNoteList()
    }
    
    // MARK: - Private functions
    private func passRequest() {
        interactor?.provideNoteDetails(request: .provideNoteDetails)
    }
    
    private func setupUI() {
        setupDateLabel()
        setupNoteHeaderTextField()
        setupNoteBodyTextView()
        setupBarButtonItem()
        registerForKeyboardNotifications()
    }
    
    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = NoteDetailsInteractor()
        let presenter = NoteDetailsPresenter()
        let router = NoteDetailsRouter()
        let worker = NoteDetailsWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Setup UI Methods
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
    
    // MARK: - @objc methods
    @objc private func readyBarButtonAction() {
        view.endEditing(true)
        interactor?.provideNoteDetails(request: .saveNote(
            noteHeader: noteHeaderTextField.text ?? "",
            noteText: noteBodyTextView.text ?? "",
            noteDate: .now
        ))
    }
}

// MARK: - Private methods
extension NoteDetailsViewController {
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
    
    private func formatDate(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YYYY EEEE HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - UITextView Delegate
extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = noteBodyTextView.endOfDocument
        noteBodyTextView.selectedTextRange = noteBodyTextView.textRange(from: newPosition, to: newPosition)
    }
}

// MARK: - Configure keyboard Notifications
extension NoteDetailsViewController {
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

// MARK: - NoteDetails display logic
extension NoteDetailsViewController: NoteDetailsDisplayLogic {
    func displayNoteDetails(viewModel: NoteDetails.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNoteDetails(noteHeader: let noteHeader, noteText: let noteText, noteDate: let noteDate):
            noteHeaderTextField.text = noteHeader
            noteBodyTextView.text = noteText
            dateLabel.text = noteDate
        case .showAlert:
            showAlert()
        }
    }
}
