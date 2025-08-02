//
//  NoteModuleBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

class NoteListModuleBuilder {
    static func build() -> NoteListView {
        let restNoteService = RestNoteService()
        let coreDataManager = CoreDataManager()
        
        let interactor = NoteListInteractor(noteService: restNoteService, storeManger: coreDataManager)
        let router = NoteListRouter()
        let presenter = NoteListPresenter(router: router, interactor: interactor)
        
        interactor.presenter = presenter
        router.presenter = presenter
        
        let view = NoteListView()
        view.presenter = presenter
        router.view = view
        presenter.view = view
        
        return view
    }
}
