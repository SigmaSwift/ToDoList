//
//  DesignSystem.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 03.08.25.
//

import Foundation
import UIKit

protocol DesignSystem {
    func color(_ kind: Color) -> UIColor
    func font(_ kind: Font) -> UIFont
    // can be added funcs for padding, spacing and more.
}

struct AppDesignSystem: DesignSystem {
    // No need to implement
    public var isDarkMode: Bool = true
    
    public func color(_ kind: Color) -> UIColor {
        let color: UIColor?
        switch kind {
        case .primaryWhite:
            color = .init(hex: "#F4F4F4")
        case .primaryBlack:
            color = .init(hex: "#040404")
        case .primaryGray:
            color = .init(hex: "#272729")
        case .secondaryGray:
            color = .init(hex: "#4D555E")
        case .darkYellow:
            color = .init(hex: "#FED702")
        }
        
        return color ?? .red
    }
    
    public func font(_ kind: Font) -> UIFont {
        let font: UIFont
        switch kind {
        case .small:
            font = .systemFont(ofSize: 12)
        case .medium:
            font = .systemFont(ofSize: 16)
        case .large:
            font = .boldSystemFont(ofSize: 32)
        case .custom(let size, let bold):
            font = bold ? .boldSystemFont(ofSize: size) : .systemFont(ofSize: size)
        }
        
        return font
    }
}

enum Color {
    case primaryWhite
    case primaryBlack
    
    case primaryGray
    case secondaryGray
    
    case darkYellow
}

enum Font {
    case small
    case medium
    case large
    case custom(_ size: CGFloat, _ bold: Bool)
}
