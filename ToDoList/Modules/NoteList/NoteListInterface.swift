//
//  NoteListInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteListView: AnyObject {
    func show(_ notes: [Note])
    func update(_ notes: [Note])
}

protocol INoteListPresenter: AnyObject {
    func viewDidLoaded()
    @MainActor
    func didLoad(_ notes: [Note])
    func didTapOn(_ note: Note, isEditable: Bool)
    func filterNotes(with key: String)
    func delete(_ id: Int)
    func addNoteDidTap()
}

protocol INoteListInteractor: AnyObject {
    func loadList() async throws
    func save(_ note: Note)
    func update(_ note: Note)
    func deleteNote(with id: Int)
}

protocol INoteListRouter: AnyObject {
    func openDetails(with note: Note, isEditable: Bool)
    func presentAddNote()
}
