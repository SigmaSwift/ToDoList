//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

class ListInteractor: IListInteractor {
    weak var presenter: IListPresenter?
    private let noteService: NoteService
    
    init(noteService: NoteService) {
        self.noteService = noteService
    }
    
    func loadList() {
        noteService.getNotes { [weak self] notes in
            guard let self else { return }
            
            presenter?.didLoad(notes)
        }
    }
}
