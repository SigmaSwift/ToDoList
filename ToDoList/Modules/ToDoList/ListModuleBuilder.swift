//
//  ListModuleBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

class ListModuleBuilder {
    static func build() -> ListView {
        let view = ListView()
        let restNoteService = RestNoteService()
        
        let interactor = ListInteractor(noteService: restNoteService)
        let router = ListRouter()
        let presenter = ListPresenter(router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        router.view = view
        presenter.view = view
        
        return view
    }
}
