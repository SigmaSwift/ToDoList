//
//  ToDoListInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol IListView: AnyObject {
    func show(_ notes: [Note])
}

protocol IListPresenter: AnyObject {
    func viewDidLoaded()
    func didLoad(_ notes: [Note])
    func didTap(_ note: Note)
}

protocol IListInteractor: AnyObject {
    func loadList()
}

protocol IListRouter: AnyObject {
    func openDetails(with note: Note)
}
