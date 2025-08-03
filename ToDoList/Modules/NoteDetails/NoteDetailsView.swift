//
//  NoteDetailsView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

class NoteDetailsView: UIViewController, UITextFieldDelegate {
    var presenter: INoteDetailsPresenter?
    var designSystem: DesignSystem!
    
    private let header: UILabel = .init()
    private let textField: UITextField = .init()
    private let dateLabel: UILabel = .init()
    private let textView: UITextView = .init()
    private let checkmarkView: UIButton = .init()
    
    private var completed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter?.viewDidLoaded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        presenter?.updatNoteIfNeeded(textField.text ?? "", body: textView.text ?? "", completed: completed)
    }
    
    private func setup() {
        view.backgroundColor = designSystem.color(.primaryBlack)
        
        let vStack = UIStackView(arrangedSubviews: [ checkmarkView, textField, dateLabel, textView ])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.setCustomSpacing(5, after: textField)
        
        let textColor = designSystem.color(.primaryWhite)
        header.textColor = textColor
        header.font = designSystem.font(.large)
        
        dateLabel.textColor = textColor
        checkmarkView.addTarget(self, action: #selector(completedButtonTap(_:)), for: .touchUpInside)
        
        textField.backgroundColor = designSystem.color(.primaryGray)
        textField.textColor = textColor
        textField.font = designSystem.font(.custom(27, false))
        textField.borderStyle = .roundedRect
        
        textView.backgroundColor = designSystem.color(.primaryGray)
        textView.textColor = textColor
        textView.font = designSystem.font(.custom(22, false))
        textView.layer.borderColor = designSystem.color(.secondaryGray).cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 5
        
        [ header, vStack, checkmarkView ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
    
    private func image(for completed: Bool) -> UIImage? {
        completed ? UIImage(named: "done-circle") : UIImage(named: "empty-circle")
    }
    
    @objc
    private func completedButtonTap(_ sender: UIButton) {
        completed = !completed
        
        sender.setImage(image(for: completed), for: .normal)
    }
}

extension NoteDetailsView: INoteDetailsView {
    func configure(with note: Note, screenTitle: String, isEditable: Bool) {
        header.text = screenTitle
                
        textField.text = note.title ?? "\(note.id)"
        dateLabel.text = note.date?.description
        textView.text = note.todo
        completed = note.completed
        checkmarkView.setImage(image(for: note.completed), for: .normal)
                
        textView.isSelectable = isEditable
        textField.isEnabled = isEditable
        checkmarkView.isEnabled = isEditable
        
        if isEditable {
            textField.becomeFirstResponder()
        }
    }
}
