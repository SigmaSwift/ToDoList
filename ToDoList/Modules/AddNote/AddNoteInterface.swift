//
//  AddNoteInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol IAddNoteView: AnyObject {
    func showAlert(with title: String, body: String)
    func dismiss()
}

protocol IAddNotePresenter: AnyObject {
    func save(_ note: Note)
    func show(title: String, error description: String)
    func dismiss()
    func addedNote(_ note: Note)
}

protocol IAddNoteInteractor: AnyObject {
    func saveIntoDatabase(_ note: Note)
}

protocol IAddNoteRouter: AnyObject { }
