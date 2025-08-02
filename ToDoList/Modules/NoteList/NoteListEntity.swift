//
//  ToDoListEntity.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
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
    let userId: Int
    
    var title: String?
    var todo: String
    var completed: Bool
    var date: String?
    
    init(
        id: Int,
        title: String? = nil,
        todo: String,
        completed: Bool,
        userId: Int,
        date: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.todo = todo
        self.completed = completed
        self.date = date
    }
}

extension Note: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.todo == rhs.todo &&
            lhs.completed == rhs.completed
    }
}
