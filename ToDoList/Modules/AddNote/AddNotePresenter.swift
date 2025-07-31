//
//  IAddNotePresenter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol IAddNoteModuleOutput: AnyObject {
    func addedNote(_ note: Note)
}

class AddNotePresenter {
    private var router: IAddNoteRouter
    private var interactor: IAddNoteInteractor
    
    weak var view: IAddNoteView?
    weak var output: IAddNoteModuleOutput?
    
    init(router: IAddNoteRouter, interactor: IAddNoteInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension AddNotePresenter: IAddNotePresenter {
    func show(title: String, error description: String) {
        view?.showAlert(with: title, body: description)
    }
    
    func save(_ note: Note) {
        interactor.saveIntoDatabase(note)
    }
    
    func addedNote(_ note: Note) {
        output?.addedNote(note)
    }
    
    func dismiss() {
        view?.dismiss()
    }
}
