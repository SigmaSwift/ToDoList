//
//  NoteModuleBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

class NoteListModuleBuilder {
    static func build() -> NoteListView {
        let view = NoteListView()
        let restNoteService = RestNoteService()
        
        let interactor = NoteListInteractor(noteService: restNoteService)
        let router = NoteListRouter()
        let presenter = NoteListPresenter(router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        router.view = view
        presenter.view = view
        
        return view
    }
}
