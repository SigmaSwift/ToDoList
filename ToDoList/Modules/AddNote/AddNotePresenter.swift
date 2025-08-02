//
//  IAddNotePresenter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol IAddNoteModuleOutput: AnyObject {
    func addedNote(with title: String, and body: String)
}

class AddNotePresenter {
    weak var output: IAddNoteModuleOutput?
}

extension AddNotePresenter: IAddNotePresenter {
    func addNote(with title: String, and body: String) {
        output?.addedNote(with: title, and: body)
    }
}
