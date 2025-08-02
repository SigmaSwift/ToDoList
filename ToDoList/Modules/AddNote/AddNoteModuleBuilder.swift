//
//  AddNoteBuilder.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import UIKit

class AddNoteModuleBuilder {
    static func build(output: IAddNoteModuleOutput?) -> AddNoteView {
        let presenter = AddNotePresenter()
        presenter.output = output
        
        let view = AddNoteView()
        view.presenter = presenter
        
        return view
    }
}
