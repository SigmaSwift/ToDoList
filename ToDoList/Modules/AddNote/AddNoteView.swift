//
//  AddNote.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import UIKit

class AddNoteView: UIViewController {
    var presenter: IAddNotePresenter?
    
    private let titleField: UITextField = .init()
    private let descriptionView: UITextView = .init()
    
    var lastNoteId: Int = .zero
    var userId: Int = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        view.backgroundColor = .systemGreen
    }
    
    private func setup() {
        let titleLabel = UILabel()
        titleLabel.text = "Add note"
        
        let closeButton = UIButton(type: .close)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let saveButton = UIButton(type: .custom)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)
        
        let hStack = UIStackView(arrangedSubviews: [ closeButton, titleLabel, saveButton ])
        hStack.axis = .horizontal
        hStack.distribution = .equalCentering
        
        titleField.placeholder = "Title..."
        titleField.borderStyle = .roundedRect
        titleField.keyboardType = .numberPad
        
        descriptionView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 5
        
        let vStack = UIStackView(arrangedSubviews: [ hStack, titleField, descriptionView ])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vStack)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        guard titleField.hasText, descriptionView.hasText else { return }
        
        let newNote = Note(
            id: lastNoteId + 1,
            title: titleField.text,
            todo: descriptionView.text,
            completed: false,
            userId: userId
        )
        
        presenter?.save(newNote)
        dismiss(animated: true)
    }
}

extension AddNoteView: IAddNoteView { }
