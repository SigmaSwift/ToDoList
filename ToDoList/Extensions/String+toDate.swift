//
//  String+toDate.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 03.08.25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.date(from: self)
    }
}
