//
//  AddNoteInteractor.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

class AddNoteInteractor: IAddNoteInteractor {
    weak var presenter: IAddNotePresenter?
    
    
    func saveToDataBase(_ note: Note) {
        print("Note: \(note)")
    }
}
