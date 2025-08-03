//
//  RestNoteService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteService {
    func fetchNotes(completion: @escaping (Result<[Note], HTTPError>) -> Void)
}

class RestNoteService: INoteService {
    private func getData(completion: @escaping (Result<ToDos, HTTPError>) -> Void) {
        guard let endpoint: URL = .init(string: "https://dummyjson.com/todos") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: endpoint)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let todos = try decoder.decode(ToDos.self, from: data)
                completion(.success(todos))
            } catch {
                completion(.failure(.invalidParsing))
            }
        }.resume()
    }
    
    func fetchNotes(completion: @escaping (Result<[Note], HTTPError>) -> Void) {
        getData { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data.todos))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

enum HTTPError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case invalidParsing
}
