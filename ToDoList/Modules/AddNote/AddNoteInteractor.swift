//
//  AddNoteInteractor.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

class AddNoteInteractor: IAddNoteInteractor {
    private let storeManager: ICoreDataManager
    weak var presenter: IAddNotePresenter?
    
    init(storeManager: ICoreDataManager) {
        self.storeManager = storeManager
    }
    
    func saveIntoDatabase(_ note: Note) {
        do {
            try storeManager.save(note: note)
            presenter?.addedNote(note)
            presenter?.dismiss()
        } catch {
            presenter?.show(
                title: "Saving Error",
                error: error.localizedDescription
            )
        }
    }
}
