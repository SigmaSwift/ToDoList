//
//  NoteListRouter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

class NoteListRouter: INoteListRouter {
    weak var view: NoteListView?
    weak var presenter: NoteListPresenter?
    
    func openDetails(with note: Note, isEditable: Bool) {
        let noteDetailsView = NoteDetailsModuleBuilder.build(note: note, isEditable: isEditable, output: presenter)
        view?.navigationController?.pushViewController(noteDetailsView, animated: true)
    }
    
    func presentAddNote() {
        let addNoteView = AddNoteModuleBuilder.build(output: presenter)
        view?.present(addNoteView, animated: true)
    }
}
