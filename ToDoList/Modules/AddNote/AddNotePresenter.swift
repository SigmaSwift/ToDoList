//
//  IAddNotePresenter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

class AddNotePresenter {
    weak var view: IAddNoteView?
    var router: IAddNoteRouter
    var interactor: IAddNoteInteractor
    
    init(router: IAddNoteRouter, interactor: IAddNoteInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension AddNotePresenter: IAddNotePresenter {
    func save(_ note: Note) {
        interactor.saveToDataBase(note)
    }
}
