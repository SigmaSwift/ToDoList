//
//  NoteDetailsInterface.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import Foundation

protocol INoteDetailsView: AnyObject {}

protocol INoteDetailsPresenter: AnyObject {
    func saveState()
}

protocol INoteDetailsInteractor: AnyObject {}

protocol INoteDetailsRouter: AnyObject {}
