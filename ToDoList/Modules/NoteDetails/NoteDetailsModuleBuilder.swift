//
//  NoteDetailsModuleBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class NoteDetailsModuleBuilder {
    static func build(note: Note, isEditable: Bool) -> NoteDetailsView {
        let view = NoteDetailsView()
        view.set(note, isEditable: isEditable)
        
        let interactor = NoteDetailsInteractor()
        let router = NoteDetailsRouter()
        let presenter = NoteDetailsPresenter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        router.view = view
        presenter.view = view
        
        return view
    }
}
