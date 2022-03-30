//
//  ViewController.swift
//  NoteApp
//
//  Created by asbul on 25.03.2022.
//

import UIKit

class NewNoteViewController: UIViewController {
    private var readyBarButtonItem = UIBarButtonItem()
    private var noteHeaderTextField = UITextField()
    private var noteBodyTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New note"
        
        setupBarButtonItem()
        setupStackView()
        
        noteBodyTextView.becomeFirstResponder()

        
        if let noteText = UserDefaults.standard.string(forKey: "NoteText") {
            noteBodyTextView.text = noteText
        }
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(noteHeaderTextField)
        noteHeaderTextField.backgroundColor = .lightGray
        noteHeaderTextField.placeholder = "Enter title of the note"
        noteHeaderTextField.font = .boldSystemFont(ofSize: 22)
        noteHeaderTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        noteHeaderTextField.borderStyle = .roundedRect
        
        stackView.addArrangedSubview(noteBodyTextView)
        noteBodyTextView.text = "Add text of your note here"
        noteBodyTextView.layer.cornerRadius = 8
        noteBodyTextView.backgroundColor = .black.withAlphaComponent(0.1)
        noteBodyTextView.font = .systemFont(ofSize: 14)
        
    }
    
    private func setupBarButtonItem() {
        readyBarButtonItem.title = "Ready"
        navigationItem.rightBarButtonItem = readyBarButtonItem
        readyBarButtonItem.target = self
        readyBarButtonItem.action = #selector(readyBarButtonAction)
    }
    
    @objc private func readyBarButtonAction() {
        view.endEditing(true)
        
        guard let noteText = noteBodyTextView.text else { return }
        UserDefaults.standard.set(noteText, forKey: "NoteText")
    }
}
