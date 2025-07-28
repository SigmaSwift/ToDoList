//
//  UILabel+setStrikethroughText.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import UIKit

extension UILabel {
    func setStrikethroughText(_ text: String, _ color: UIColor?) {
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: color ?? .black
            ]
        )
        
        attributedText = attributedString
    }
}
