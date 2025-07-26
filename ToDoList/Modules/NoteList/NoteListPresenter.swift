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
    func didLoad(_ notes: [Note]) {
        view?.show(notes)
    }
    
    func didTap(_ note: Note, isEditable: Bool) {
        router.openDetails(with: note, isEditable: isEditable)
    }
    
    func viewDidLoaded() {
        interactor.loadList()
    }
}
