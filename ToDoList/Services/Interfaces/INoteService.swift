//
//  INoteService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol INoteService {
    func getData() async throws -> ToDos
    func getNotes() async throws -> [Note]
}

