//
//  NoteDetailsInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteDetailsView: AnyObject {
    func configure(with note: Note, screenTitle: String, isEditable: Bool)
}

protocol INoteDetailsPresenter: AnyObject {
    func viewDidLoaded()
    func updatNoteIfNeeded(_ title: String, body: String, completed: Bool)
}
