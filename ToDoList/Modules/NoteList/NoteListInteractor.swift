//
//  NoteListInteractor.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class NoteListInteractor {
    weak var presenter: INoteListPresenter?
    private let noteService: INoteService
    private let storeManager: ICoreDataManager
    
    init(noteService: INoteService, storeManger: ICoreDataManager) {
        self.noteService = noteService
        self.storeManager = storeManger
    }
}

extension NoteListInteractor: INoteListInteractor {
    func loadList() async throws {
        let storedNotes = try storeManager.fetchNotes()
        if !storedNotes.isEmpty {
            await presenter?.didLoad(storedNotes)
        } else {
            let fetchedNotes = try await noteService.fetchNotes()
            if !fetchedNotes.isEmpty {
                await presenter?.didLoad(fetchedNotes)
                
                try storeManager.save(notes: fetchedNotes)
            }
        }
    }
    
    func save(_ note: Note) {
        Task(priority: .background) {
            try storeManager.save(note)
        }
    }
    
    func update(_ note: Note) {
        Task(priority: .background) {
            try storeManager.update(note)
        }
    }
    
    func deleteNote(with id: Int) {
        Task(priority: .background) {
            try storeManager.deleteNote(with: id)
        }
    }
}
