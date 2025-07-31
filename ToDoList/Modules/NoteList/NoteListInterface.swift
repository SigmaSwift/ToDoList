//
//  NoteListInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteListView: AnyObject {
    func show(_ notes: [Note])
    func updateNotesList(with note: Note)
    func dismissAlert()
}

protocol INoteListPresenter: AnyObject {
    func viewDidLoaded()
    func didLoad(_ notes: [Note])
    func didTapOn(_ note: Note, isEditable: Bool)
    func delete(_ id: Int)
    func addNoteDidTap()
}

protocol INoteListInteractor: AnyObject {
    func loadList() async throws
    func deleteNote(with id: Int)
    
    func getLastId() -> Int
    func generateUserId() -> Int
}

protocol INoteListRouter: AnyObject {
    func openDetails(with note: Note, isEditable: Bool)
    func presentAddNote(_ lastId: Int, userId: Int)
}
