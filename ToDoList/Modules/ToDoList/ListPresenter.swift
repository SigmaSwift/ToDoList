//
//  IListPresenter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

class ListPresenter {
    weak var view: IListView?
    var router: IListRouter
    var interactor: IListInteractor
    
    init(router: IListRouter, interactor: IListInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ListPresenter: IListPresenter {
    func didLoad(_ notes: [Note]) {
        
    }
    
    func didTap(_ note: Note) {
        router.openDetails(with: note)
    }
    
    func viewDidLoaded() {
        interactor.loadList()
    }
}
