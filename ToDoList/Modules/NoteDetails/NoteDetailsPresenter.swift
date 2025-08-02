//
//  NoteDetailsPresenter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteDetailsModuleOutput: AnyObject {
    func updated(_ note: Note)
}

class NoteDetailsPresenter {
    weak var view: NoteDetailsView?
    weak var output: INoteDetailsModuleOutput?
    
    private var note: Note
    private let isEditable: Bool
        
    init(note: Note, isEditable: Bool) {
        self.note = note
        self.isEditable = isEditable
    }
}

extension NoteDetailsPresenter: INoteDetailsPresenter {
    func viewDidLoaded() {
        let screenTitle = isEditable ? "Edit Mode" : "Details"
        view?.configure(with: note, screenTitle: screenTitle, isEditable: isEditable)
    }
    
    func updatNoteIfNeeded(_ title: String, body: String, completed: Bool) {
        guard !title.isEmpty || !body.isEmpty else { return }
        
        let updatedNote = Note(
            id: note.id,
            title: title,
            todo: body,
            completed: completed,
            userId: note.userId,
            date: note.date
        )
        
        guard updatedNote != note else { return }
                
        output?.updated(updatedNote)
    }
}
