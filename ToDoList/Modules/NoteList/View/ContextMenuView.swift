//
//  ContextMenuView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 31.07.25.
//

import UIKit
import Foundation

final class ContextMenuView: UIView {
    private let designSystem: DesignSystem = AppDesignSystem()
    
    private var title: String?
    private var body: String?
    private var date: String?

    private let popup: PopupView = .init()
    var alert: AlertView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func update(_ content: Note) {
        popup.update(content)
    }
    
    private func setup() {
        alert.set(models: [
            .init(text: "Edit", image: "square.and.pencil", action: .edit),
            .init(text: "Share", image: "square.and.arrow.up", action: .share),
            .init(text: "Delete", image: "trash.slash", action: .delete, tint: .red)
        ])
        
        [ popup, alert ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            popup.topAnchor.constraint(equalTo: topAnchor),
            popup.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            popup.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            popup.bottomAnchor.constraint(equalTo: alert.topAnchor, constant: -padding / 2),
            
            
            alert.heightAnchor.constraint(equalToConstant: 132),
            alert.widthAnchor.constraint(equalToConstant: 254),
            alert.centerXAnchor.constraint(equalTo: popup.centerXAnchor)
        ])
    }
    
    private class PopupView: UIView {
        private let designSystem: DesignSystem = AppDesignSystem()
        
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
            let primaryTextColor = designSystem.color(.primaryWhite)
            let secondaryTextColor = designSystem.color(.secondaryGray)
            
            backgroundColor = designSystem.color(.primaryGray)
            layer.cornerRadius = 10
            
            titleLabel.numberOfLines = 1
            titleLabel.textColor = primaryTextColor
            titleLabel.font = designSystem.font(.custom(21, false))
            
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textColor = primaryTextColor
            descriptionLabel.font = designSystem.font(.custom(18, true))
            
            dateLabel.numberOfLines = 1
            dateLabel.textColor = secondaryTextColor
        
            let vStack = UIStackView(arrangedSubviews: [ titleLabel, descriptionLabel, dateLabel ])
            vStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.axis = .vertical
            vStack.distribution = .fill
            vStack.spacing = 10
            
            addSubview(vStack)
            
            let hPadding: CGFloat = 16
            let vPadding: CGFloat = 12
            NSLayoutConstraint.activate([
                vStack.topAnchor.constraint(equalTo: topAnchor, constant: vPadding),
                vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: hPadding),
                vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -hPadding),
                vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -vPadding)
            ])
        }
    }
}
