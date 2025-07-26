//
//  RestNoteService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol NoteService {
    func getData() async throws -> ToDos
    func getNotes() async throws -> [Note]
}

class RestNoteService: NoteService {
    func getData() async throws -> ToDos {
        guard let endpoint: URL = .init(string: "https://dummyjson.com/todos") else {
            throw TaskError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw TaskError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ToDos.self, from: data)
        } catch {
            throw TaskError.invalidData
        }
    }
    
    func getNotes() async throws -> [Note] {
        do {
            let todos = try await getData()
            return todos.todos
        } catch {
            throw TaskError.invalidResponse
        }
    }
}

enum TaskError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
}
