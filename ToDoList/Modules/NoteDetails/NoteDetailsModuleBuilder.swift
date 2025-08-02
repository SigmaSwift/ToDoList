//
//  NoteDetailsModuleBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class NoteDetailsModuleBuilder {
    static func build(note: Note, isEditable: Bool, output: INoteDetailsModuleOutput?) -> NoteDetailsView {
        let view = NoteDetailsView()
        let presenter = NoteDetailsPresenter(note: note, isEditable: isEditable)
        
        view.presenter = presenter
        presenter.view = view
        presenter.output = output
    
        return view
    }
}
