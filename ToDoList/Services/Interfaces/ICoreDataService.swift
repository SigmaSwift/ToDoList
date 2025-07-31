//
//  ICoreDataService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol ICoreDataManager {
    func save(notes: [Note]) throws
    func save(note: Note) throws
    func fetchNotes() throws -> [Note]
    func updateNote(
        with id: Int,
        title: String,
        description: String,
        isCompleted: Bool
    ) throws
    func deleteNote(with id: Int) throws
}
