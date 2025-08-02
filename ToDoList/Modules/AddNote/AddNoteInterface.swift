//
//  AddNoteInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol IAddNotePresenter: AnyObject {
    func addNote(with title: String, and body: String)
}

protocol IAddNoteView: AnyObject {}

protocol IAddNoteInteractor: AnyObject { }

protocol IAddNoteRouter: AnyObject { }
