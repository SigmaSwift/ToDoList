//
//  NoteListInteractor.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

class NoteListInteractor: INoteListInteractor {
    weak var presenter: INoteListPresenter?
    private let noteService: INoteService
    
    private var notes: [Note] = []
    
    init(noteService: INoteService) {
        self.noteService = noteService
    }
    
    func loadList() {
        Task {
            do {
                notes = try await noteService.getNotes()
                presenter?.didLoad(notes)
            } catch {
                print("error: ", error.localizedDescription)
            }
        }
    }
    
    func generateUserId() -> Int {
        let userIds = notes.map { $0.userId }
        var newUserId: Int
        
        repeat {
            newUserId = Int.random(in: 1...999)
        } while userIds.contains(newUserId)
        
        return newUserId
    }
    
    func getLastId() -> Int {
        notes.map { $0.id }.max() ?? .zero
    }
}
