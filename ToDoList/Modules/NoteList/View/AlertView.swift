//
//  AlertView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import UIKit

class AlertView: UIView {
    struct AlertModel {
        enum Action {
            case edit
            case share
            case delete
        }
        
        let text: String
        let image: String
        let action: Action
        var tint: UIColor?
    }
    
    private var content: [UIView] = []
    
    var didTap: ((AlertModel.Action) -> Void)?
    
    func set(models: [AlertModel]) {
        for (index, model) in models.enumerated() {
            let label = UILabel()
            let image = UIImageView(image: UIImage(systemName: model.image))
            
            label.text = model.text
            label.textColor = model.tint ?? .black
            image.tintColor = model.tint ?? .black
            
            let hStack = TappableStack(arrangedSubviews: [ label, image ])
            hStack.actionType = model.action
            hStack.didTap = { [weak self] type in
                guard let self else { return }
                
                didTap?(type)
            }
            
            content.append(hStack)
            if index < models.count - 1 {
                content.append(line())
            }
        }
        
        let vStack = UIStackView(arrangedSubviews: content)
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.spacing = 10
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(blurView, at: 0)
        
        let padding: CGFloat = 14
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    private func line() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .darkGray
        return view
    }
    
    private class TappableStack: UIStackView {
        var actionType: AlertModel.Action?
        var didTap: ((AlertModel.Action) -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            axis = .horizontal
            distribution = .equalSpacing
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        @objc
        private func tap() {
            guard let actionType else { return }
            
            didTap?(actionType)
        }
    }
}
