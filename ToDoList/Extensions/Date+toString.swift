//
//  Date+toString.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 03.08.25.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
}
