//
//  INotePresenter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class NoteListPresenter {
    weak var view: INoteListView?
    var router: INoteListRouter
    var interactor: INoteListInteractor
    
    private var notes: [Note] = []
    
    init(router: INoteListRouter, interactor: INoteListInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    private func generateUserId() -> Int {
        var newUserId: Int
        
        repeat {
            newUserId = Int.random(in: 1...999)
        } while notes.map { $0.userId }.contains(newUserId)
        
        return newUserId
    }
    
    private func getLastId() -> Int {
        notes.map { $0.id }.max() ?? .zero
    }
}

extension NoteListPresenter: INoteListPresenter {
    func viewDidLoaded() {
        Task(priority: .background) {
            try await interactor.loadList()
        }
    }
    
    @MainActor
    func didLoad(_ notes: [Note]) {
        self.notes = notes
        view?.show(notes)
    }
    
    func filterNotes(with key: String) {
        if key.isEmpty {
            view?.update(notes)
        } else {
            let filteredNotes = notes.filter {$0.todo.lowercased().contains(key.lowercased())}
            view?.update(filteredNotes)
        }
    }
    
    func delete(_ id: Int) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes.remove(at: index)
            view?.update(notes)
        }
        
        interactor.deleteNote(with: id)
    }
    
    func didTapOn(_ note: Note, isEditable: Bool) {
        router.openDetails(with: note, isEditable: isEditable)
    }
    
    func addNoteDidTap() {
        router.presentAddNote()
    }
}

extension NoteListPresenter: IAddNoteModuleOutput {
    func addedNote(with title: String, and body: String) {
        let note: Note = .init(
            id: getLastId() + 1,
            title: title,
            todo: body,
            completed: false,
            userId: generateUserId(),
            date: Date.now.toString()
        )
        
        notes.append(note)
        view?.update(notes)
        
        interactor.save(note)
    }
}

extension NoteListPresenter: INoteDetailsModuleOutput {
    func updated(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
            notes.insert(note, at: index)
            view?.update(notes)
            
            interactor.update(note)
        }
    }
}
