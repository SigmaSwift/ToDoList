//
//  NoteListInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteListView: AnyObject {
    func show(_ notes: [Note])
    func showAlert(_ title: String, body: String)
    func update(_ notes: [Note])
}

protocol INoteListPresenter: AnyObject {
    func viewDidLoaded()
    func didLoad(_ notes: [Note])
    func didTapOn(_ note: Note, isEditable: Bool)
    func filterNotes(with key: String)
    func delete(_ id: Int)
    func addNoteDidTap()
    func sendError(with title: String, body: String)
}

protocol INoteListInteractor: AnyObject {
    func loadList()
    func save(_ note: Note)
    func save(_ notes: [Note])
    func update(_ note: Note)
    func deleteNote(with id: Int)
}

protocol INoteListRouter: AnyObject {
    func openDetails(with note: Note, isEditable: Bool)
    func presentAddNote()
}
