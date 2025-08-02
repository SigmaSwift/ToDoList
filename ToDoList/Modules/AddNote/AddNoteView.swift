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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleField.becomeFirstResponder()
    }
    
    private func setup() {
        view.backgroundColor = DesignSystem.Color.primaryBlack
        
        let titleLabel = UILabel()
        titleLabel.text = "Add note"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = DesignSystem.Color.primaryWhite
        
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.setTitle("Close", for: .normal)
        
        let saveButton = UIButton(type: .custom)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let hStack = UIStackView(arrangedSubviews: [ closeButton, titleLabel, saveButton ])
        hStack.axis = .horizontal
        hStack.distribution = .equalCentering
        
        titleField.placeholder = "Title..."
        titleField.borderStyle = .roundedRect
        titleField.keyboardType = .numberPad
        
        descriptionView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionView.layer.borderWidth = 2
        descriptionView.layer.cornerRadius = 5
        descriptionView.backgroundColor = .black
        descriptionView.textColor = DesignSystem.Color.primaryWhite
        descriptionView.font = .systemFont(ofSize: 24)
        
        let vStack = UIStackView(arrangedSubviews: [ hStack, titleField, descriptionView ])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vStack)
        
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding * 2)
        ])
    }
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        guard titleField.hasText, descriptionView.hasText else { return }
        
        presenter?.addNote(with: titleField.text!, and: descriptionView.text!)
        dismiss(animated: true)
    }
}

extension AddNoteView: IAddNoteView { }
