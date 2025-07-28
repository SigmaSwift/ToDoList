//
//  RestNoteService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class RestNoteService: INoteService {
    func getData() async throws -> ToDos {
        guard let endpoint: URL = .init(string: "https://dummyjson.com/todos") else {
            throw HTTPError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HTTPError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ToDos.self, from: data)
        } catch {
            throw HTTPError.invalidData
        }
    }
    
    func getNotes() async throws -> [Note] {
        do {
            let todos = try await getData()
            return todos.todos
        } catch {
            throw HTTPError.invalidResponse
        }
    }
}

enum HTTPError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
}
