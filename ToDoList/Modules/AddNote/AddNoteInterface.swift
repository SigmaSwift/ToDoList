//
//  AddNoteInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import Foundation

protocol IAddNoteView: AnyObject {
    
}

protocol IAddNotePresenter: AnyObject {
    func save(_ note: Note)
}

protocol IAddNoteInteractor: AnyObject {
    func saveToDataBase(_ note: Note)
}

protocol IAddNoteRouter: AnyObject {
   
}
