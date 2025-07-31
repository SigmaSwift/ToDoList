//
//  AddNoteBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import UIKit

class AddNoteModuleBuilder {
    static func build(
        _ lastNoteId: Int,
        userId: Int,
        moduleOutput: IAddNoteModuleOutput?
    ) -> AddNoteView {
        let view = AddNoteView()
        
        view.lastNoteId = lastNoteId
        view.userId = userId
        
        let dataManager = CoreDataManager()
        let interactor = AddNoteInteractor(storeManager: dataManager)
        let router = AddNoteRouter()
        let presenter = AddNotePresenter(router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        router.view = view
        presenter.view = view
        
        presenter.output = moduleOutput
        
        return view
    }
}
