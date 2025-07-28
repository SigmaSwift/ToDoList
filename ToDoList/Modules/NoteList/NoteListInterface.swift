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
    func didTapOn(_ note: Note, isEditable: Bool)
    func delete(_ id: Int)
    func addNote()
}

protocol INoteListInteractor: AnyObject {
    func loadList()
    func generateUserId() -> Int
    func getLastId() -> Int
}

protocol INoteListRouter: AnyObject {
    func openDetails(with note: Note, isEditable: Bool)
    func presentAddNote(_ lastId: Int, userId: Int)
}
