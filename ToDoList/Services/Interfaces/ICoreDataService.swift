//
//  ICoreDataService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol ICoreDataManager {
    func fetchNotes() throws -> [Note]
    func save(_ note: Note) throws
    func save(notes: [Note]) throws
    func update(_ note: Note) throws
    func deleteNote(with id: Int) throws
}
