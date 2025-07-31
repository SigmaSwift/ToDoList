//
//  ContextMenuView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 31.07.25.
//

import UIKit
import Foundation

class ContextMenuView: UIStackView {
    private var title: String?
    private var body: String?
    private var date: String?

    private let popup: PopupView = .init()
    var alert: AlertView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func update(_ content: Note) {
        popup.update(content)
    }
    
    private func setup() {
        axis = .vertical
        spacing = 10
                
        alert.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alert.heightAnchor.constraint(equalToConstant: 132),
            alert.widthAnchor.constraint(equalToConstant: 254)
        ])
        
        alert.set(models: [
            .init(text: "Edit", image: "square.and.pencil", action: .edit),
            .init(text: "Share", image: "square.and.arrow.up", action: .share),
            .init(text: "Delete", image: "trash.slash", action: .delete, tint: .red)
        ])
        
        addArrangedSubview(popup)
        addArrangedSubview(alert)
    }
    
    private class PopupView: UIView {
        private let titleLabel: UILabel = .init()
        private let descriptionLabel: UILabel = .init()
        private let dateLabel: UILabel = .init()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            setup()
        }
         
        func update(_ content: Note) {
            titleLabel.text = content.title ?? String(content.id)
            descriptionLabel.text = content.todo
            dateLabel.text = content.date
        }
        
        private func setup() {
            [ titleLabel, descriptionLabel, dateLabel ].forEach { $0.textColor = DesignSystem.Color.primaryWhite }
            backgroundColor = UIColor.init(hex: "#272729")
            layer.cornerRadius = 10
            
            let vStack = UIStackView(arrangedSubviews: [ titleLabel, descriptionLabel, dateLabel ])
            vStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.axis = .vertical
            vStack.distribution = .fill
            vStack.spacing = 10
            
            addSubview(vStack)
            
            let padding: CGFloat = 14
            NSLayoutConstraint.activate([
                vStack.topAnchor.constraint(equalTo: topAnchor, constant: padding),
                vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
            ])
            
            titleLabel.numberOfLines = 1
            dateLabel.numberOfLines = 1
            descriptionLabel.numberOfLines = 0
        }
    }
}
