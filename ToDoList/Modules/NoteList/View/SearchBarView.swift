//
//  SearchBarView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 28.07.25.
//

import UIKit

final class SearchBarView: UIView {
    private let searchBarContainer: UIView = .init()
    
    private let titleLabel: UILabel = .init()
    private let textField: UITextField = .init()
    private let iconView: UIImageView = .init()
    private let clearButton: UIButton = .init()
    private let cancelButton: UIButton = .init()
    
    private var searchContainerTrailingConstraint: NSLayoutConstraint?
    
    var textDidChanged: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        titleLabel.text = "Todos"
        titleLabel.textColor = DesignSystem.Color.primaryWhite
        titleLabel.font = .boldSystemFont(ofSize: 34)
        
        iconView.image = UIImage(systemName: "magnifyingglass")
        iconView.tintColor = DesignSystem.Color.secondaryGray
        
        let attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: DesignSystem.Color.secondaryGray ?? .black]
        )
        textField.attributedPlaceholder = attributedPlaceholder
        textField.textColor = DesignSystem.Color.primaryWhite
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.delegate = self
        
        clearButton.setImage(.init(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = DesignSystem.Color.secondaryGray
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.isHidden = true
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.isHidden = true
        
        searchBarContainer.layer.cornerRadius = 10
        searchBarContainer.backgroundColor = DesignSystem.Color.primaryGray
        
        let mainContainer = UIView()
        
        [
            mainContainer,
            searchBarContainer,
            titleLabel,
            iconView,
            textField,
            clearButton,
            cancelButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    
        [ iconView, textField, clearButton ].forEach { searchBarContainer.addSubview($0) }
        [ titleLabel, searchBarContainer, cancelButton ].forEach { mainContainer.addSubview($0) }
        
        searchContainerTrailingConstraint = searchBarContainer.trailingAnchor.constraint(
            equalTo: mainContainer.trailingAnchor,
            constant: -10
        )
        searchContainerTrailingConstraint?.isActive = true
        
        let iconSize: CGFloat = 24.0
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize),
            
            clearButton.heightAnchor.constraint(equalToConstant: iconSize),
            clearButton.widthAnchor.constraint(equalToConstant: iconSize),
        ])
                
        let padding: CGFloat = 10.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: searchBarContainer.topAnchor, constant: -padding),
            
            searchBarContainer.heightAnchor.constraint(equalToConstant: 36),
            
            iconView.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor, constant: padding / 2),
            iconView.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
            
            textField.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            textField.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor),
            
            clearButton.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor, constant: -padding),
            clearButton.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
                        
            searchBarContainer.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: padding),
            searchBarContainer.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -padding),
            
            cancelButton.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -padding),
            cancelButton.leadingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor, constant: padding),
            cancelButton.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -padding)
        ])
        
        addSubview(mainContainer)
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: topAnchor, constant: 44),
            mainContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            mainContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            mainContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
    
    @objc
    private func cancelButtonTapped() {
        textField.text = nil
        clearButton.isHidden = true
        
        textField.resignFirstResponder()
        textDidChanged?("")
        animateableChangeConstraint(searchContainerTrailingConstraint, constant: -10)
    }
    
    @objc
    private func clearButtonTapped() {
        textField.text = nil
        clearButton.isHidden = true
        textDidChanged?("")
    }
    
    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        guard let input = textField.text?.trimmingCharacters(in: .whitespaces), !input.isEmpty else {
            textDidChanged?("")
            return
        }
        
        textDidChanged?(input)
        clearButton.isHidden = false
    }
    
    private func animateableChangeConstraint(_ contraint: NSLayoutConstraint?, constant: CGFloat) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            
            if let contraint {
                contraint.constant = constant
            }
            
            layoutIfNeeded()
        }
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton.isHidden = false
        animateableChangeConstraint(searchContainerTrailingConstraint, constant: -80)
    }
}
