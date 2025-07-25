//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

class ListRouter: IListRouter {
    weak var view: ListView?
    
    func openDetails(with note: Note) {
        let detailsView = DetailsModuleBuilder.build(note: note)
        
        view?.navigationController?.pushViewController(detailsView, animated: true)
    }
}
