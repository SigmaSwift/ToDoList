//
//  NoteDetailsView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

class NoteDetailsView: UIViewController {
    weak var presenter: INoteDetailsPresenter?
    
    private let titleLabel: UILabel = .init()
    private let dateLabel: UILabel = .init()
    private let textView: UITextView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // save info
        presenter?.saveState()
    }
    
    func set(_ note: Note, isEditable: Bool) {
        titleLabel.text = "\(note.id)"
        dateLabel.text = note.date
        textView.text = note.todo
        textView.isEditable = isEditable
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(textView)
                
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        titleLabel.font = .systemFont(ofSize: 32)
        textView.font = .systemFont(ofSize: 25)
    }
}

extension NoteDetailsView: INoteDetailsView { }
