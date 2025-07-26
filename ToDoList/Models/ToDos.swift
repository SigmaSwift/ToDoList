//
//  ToDos.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 26.07.25.
//

import Foundation

struct ToDos: Codable {
    let todos: [Note]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Note: Codable, Hashable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    
    var date: String {
        let startDate = Calendar.current.date(from: .init(year: 2025, month: 1, day: 1))!
        let endDate = Calendar.current.date(from: .init(year: 2025, month: 12, day: 31))!
        
        let randomTimeInterval = TimeInterval.random(in: startDate.timeIntervalSinceNow...endDate.timeIntervalSinceNow)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        return dateFormatter.string(from: Date(timeIntervalSinceNow: randomTimeInterval))
    }
}
