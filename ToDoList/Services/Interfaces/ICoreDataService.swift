//
//  ICoreDataService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol ICoreDataService {
    func fetchNodes() async -> [Note]
    func addNode(_ note: Note) async
    func updateNode(_ id: Int, title: String, description: String, isCompleted: Bool) async
    func deleteNode(_ id: Int) async
}
