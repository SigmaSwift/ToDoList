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
    
    private var notesIds: [Int] = []
    private var notesUserIds: [Int] = []
    
    init(noteService: INoteService, storeManger: ICoreDataManager) {
        self.noteService = noteService
        self.storeManager = storeManger
    }
}

extension NoteListInteractor: INoteListInteractor {
    private func fetchNotes() async -> [Note]  {
        var notes: [Note] = []
        do {
            notes = try await noteService.getNotes()
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
        
        return notes
    }
    
    func loadList() async {
        var notes: [Note] = []
        do {
            notes = try storeManager.fetchNotes()
            if !notes.isEmpty {
                notesIds = notes.map { $0.id }
                notesUserIds = notes.map { $0.userId }
            
                presenter?.didLoad(notes)
                print("notes from CoreData")
            }
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
        
        if notes.isEmpty {
            let notes = await fetchNotes()
            notesIds = notes.map { $0.id }
            notesUserIds = notes.map { $0.userId }
            
            presenter?.didLoad(notes)
            print("notes from Inet")
            do {
                try storeManager.save(notes: notes)
            } catch {
                debugPrint("error when try save notes from inet")
            }
        }
    }
    
    func deleteNote(with id: Int) {
        do {
            try storeManager.deleteNote(with: id)
        } catch {
            debugPrint(#function)
        }
    }
    
    func generateUserId() -> Int {
        var newUserId: Int
        
        repeat {
            newUserId = Int.random(in: 1...999)
        } while notesUserIds.contains(newUserId)
        
        return newUserId
    }
    
    func getLastId() -> Int {
        notesIds.max() ?? .zero
    }
}
