//
//  DetailsModuleBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class DetailsModuleBuilder {
    static func build(note: Note) -> DetailsView {
        let view = DetailsView(note: note)
        
        let interactor = DetailsInteractor()
        let router = DetailsRouter()
        let presenter = DetailsPresenter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        router.view = view
        presenter.view = view
        
        return view
    }
}
