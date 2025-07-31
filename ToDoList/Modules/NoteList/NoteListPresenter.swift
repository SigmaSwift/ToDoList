//
//  INotePresenter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class NoteListPresenter {
    weak var view: INoteListView?
    var router: INoteListRouter
    var interactor: INoteListInteractor
    
    init(router: INoteListRouter, interactor: INoteListInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension NoteListPresenter: INoteListPresenter {
    func delete(_ id: Int) {
        interactor.deleteNote(with: id)
        view?.dismissAlert()
    }
    
    func didTapOn(_ note: Note, isEditable: Bool) {
        router.openDetails(with: note, isEditable: isEditable)
    }
    
    func addNoteDidTap() {
        let id = interactor.getLastId()
        let userId = interactor.generateUserId()
       
        router.presentAddNote(id, userId: userId)
    }
    
    func didLoad(_ notes: [Note]) {
        view?.show(notes)
    }
    
    func viewDidLoaded() {
        Task {
            try await interactor.loadList()
        }
    }
}

extension NoteListPresenter: IAddNoteModuleOutput {
    func addedNote(_ note: Note) {
        view?.updateNotesList(with: note)
    }
}
