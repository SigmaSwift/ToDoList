//
//  NoteCell.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import UIKit

final class NoteCellView: UITableViewCell {
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let dateLabel: UILabel = .init()
    private let checkmarkView: UIImageView = .init()
    
    private let hStack: UIStackView = .init()
    private let vStack: UIStackView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = DesignSystem.Color.primaryWhite
        
        vStack.axis = .vertical
        vStack.spacing = 4
        
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .top
        
        [ titleLabel, descriptionLabel, dateLabel ].forEach { vStack.addArrangedSubview($0) }
        [ checkmarkView, vStack ].forEach { hStack.addArrangedSubview($0) }
        
        [ hStack, checkmarkView ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        contentView.addSubview(hStack)
        contentView.backgroundColor = .black
        
        descriptionLabel.numberOfLines = 0
        
        let padding: CGFloat = 10.0
        NSLayoutConstraint.activate([
            checkmarkView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkView.heightAnchor.constraint(equalToConstant: 24),
            
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding * 2),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding * 2),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(with note: Note) {
        let tintColor: UIColor?
        let secondaryGray = DesignSystem.Color.secondaryGray
        if note.completed {
            tintColor = secondaryGray
            
            checkmarkView.image = UIImage(named: "done-circle")
            titleLabel.setStrikethroughText(note.title ?? String(note.id), tintColor)
        } else {
            tintColor = DesignSystem.Color.primaryWhite
            
            checkmarkView.image = UIImage(named: "empty-circle")
            titleLabel.attributedText = nil
            titleLabel.text = note.title ?? String(note.id)
            titleLabel.textColor = tintColor
        }
        
        descriptionLabel.text = note.todo
        descriptionLabel.textColor = tintColor
        
        dateLabel.text = note.date
        dateLabel.textColor = secondaryGray
    }
}
