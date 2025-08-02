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
    func loadList() {
        do {
            let storedNotes = try storeManager.fetchNotes()
            if !storedNotes.isEmpty {
                presenter?.didLoad(storedNotes)
            } else {
                noteService.fetchNotes { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let notes):
                        presenter?.didLoad(notes)
                        if !notes.isEmpty {
                            save(notes)
                        }
                    case .failure(let error):
                        presenter?.sendError(with: "Fetching from server not successful!", body: error.localizedDescription)
                    }
                }
            }
        } catch {
            presenter?.sendError(with: "Fetching from DB not successful!", body: error.localizedDescription)
        }
    }
    
    func save(_ note: Note) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            do {
                try storeManager.save(note)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    presenter?.sendError(with: "Saving into DB not successful!", body: error.localizedDescription)
                }
            }
        }
    }
    
    func save(_ notes: [Note]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            do {
                try storeManager.save(notes: notes)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    presenter?.sendError(with: "Saving into DB not successful!", body: error.localizedDescription)
                }
            }
        }
    }
    
    func update(_ note: Note) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            do {
                try storeManager.update(note)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    presenter?.sendError(with: "Note updating not successful!", body: error.localizedDescription)
                }
            }
        }
    }
    
    func deleteNote(with id: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            do {
                try storeManager.deleteNote(with: id)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    presenter?.sendError(with: "Note deleting problem!", body: error.localizedDescription)
                }
            }
        }
    }
}

