//
//  NoteListInteractor.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

class NoteListInteractor: INoteListInteractor {
    weak var presenter: INoteListPresenter?
    private let noteService: NoteService
    
    init(noteService: NoteService) {
        self.noteService = noteService
    }
    
    func loadList() {
        Task {
            do {
                let notes = try await noteService.getNotes()
                presenter?.didLoad(notes)
            } catch {
                print("error: ", error.localizedDescription)
            }
        }
    }
}
