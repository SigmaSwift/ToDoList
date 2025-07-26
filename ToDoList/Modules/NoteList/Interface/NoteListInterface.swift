//
//  NoteListInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteListView: AnyObject {
    func show(_ notes: [Note])
}

protocol INoteListPresenter: AnyObject {
    func viewDidLoaded()
    func didLoad(_ notes: [Note])
    func didTap(_ note: Note, isEditable: Bool)
}

protocol INoteListInteractor: AnyObject {
    func loadList()
}

protocol INoteListRouter: AnyObject {
    func openDetails(with note: Note, isEditable: Bool)
}
