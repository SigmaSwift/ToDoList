//
//  NoteListRouter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

class NoteListRouter: INoteListRouter {
    weak var view: NoteListView?
    
    func openDetails(with note: Note, isEditable: Bool) {
        let noteDetailsView = NoteDetailsModuleBuilder.build(note: note, isEditable: isEditable)
        
        view?.navigationController?.pushViewController(noteDetailsView, animated: true)
    }
}
