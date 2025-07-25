//
//  ListView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

class ListView: UIViewController {
    var presenter: IListPresenter?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoaded()
    }
    
    private func didTap(_ note: Note) {
        presenter?.didTap(note)
    }
}

extension ListView: IListView {
    func show(_ notes: [Note]) {
        guard let note = notes.first else {
            debugPrint("Empty list!")
            return
        }
        
        debugPrint("Notes: \(note.todo), comleted: \(note.completed)")
    }
}
