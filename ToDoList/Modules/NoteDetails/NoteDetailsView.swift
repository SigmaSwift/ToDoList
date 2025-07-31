//
//  NoteDetailsView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

class NoteDetailsView: UIViewController {
    weak var presenter: INoteDetailsPresenter?
    
    private let header: UILabel = .init()
    private let textField: UITextField = .init()
    private let dateLabel: UILabel = .init()
    private let textView: UITextView = .init()
    private let checkmarkView: UIButton = .init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.saveState()
    }
    
    func set(_ note: Note, isEditable: Bool) {
        header.text = isEditable ? "Edit mode" : "Details"
        
        textField.text = "\(note.id)"
        dateLabel.text = note.date.description
        textView.text = note.todo
        
        textView.isEditable = isEditable
        textField.isEnabled = isEditable
        checkmarkView.isEnabled = isEditable
        
        let image = note.completed ? UIImage(named: "done-circle") : UIImage(named: "empty-circle")
        isCompleted = note.completed
        checkmarkView.setImage(image, for: .normal)
        
        
        if isEditable {
            textField.becomeFirstResponder()
        }
    }
    
    private var isCompleted: Bool = false
    
    @objc
    private func completedButtonTap(_ sender: UIButton) {
        isCompleted = !isCompleted
        let image = isCompleted ? UIImage(named: "done-circle") : UIImage(named: "empty-circle")
        sender.setImage(image, for: .normal)
    }
    
    private func setup() {
        view.backgroundColor = DesignSystem.Color.primaryBlack
        
        checkmarkView.addTarget(self, action: #selector(completedButtonTap(_:)), for: .touchUpInside)

        
        let vStack = UIStackView(arrangedSubviews: [
            checkmarkView, textField, dateLabel, textView
        ])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.setCustomSpacing(5, after: textField)
        
        header.textColor = DesignSystem.Color.primaryWhite
        header.font = .boldSystemFont(ofSize: 32)
        
        dateLabel.textColor = DesignSystem.Color.primaryWhite
        
        textField.backgroundColor = DesignSystem.Color.primaryGray
        textField.textColor = DesignSystem.Color.primaryWhite
        textField.font = .systemFont(ofSize: 27)
        textField.borderStyle = .roundedRect
        
        textView.backgroundColor = DesignSystem.Color.primaryGray
        textView.textColor = DesignSystem.Color.primaryWhite
        textView.font = .systemFont(ofSize: 22)
        textView.layer.borderColor = DesignSystem.Color.secondaryGray?.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 5
                
        header.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vStack)
        view.addSubview(header)
        
        let padding: CGFloat = 10.0
        NSLayoutConstraint.activate([
            checkmarkView.widthAnchor.constraint(equalToConstant: 32),
            checkmarkView.heightAnchor.constraint(equalToConstant: 32),
            
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            vStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: padding),
            vStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            vStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            vStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
}

extension NoteDetailsView: INoteDetailsView { }
