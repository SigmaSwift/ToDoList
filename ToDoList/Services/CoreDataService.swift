//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import CoreData

final class CoreDataService: ICoreDataService {
    func fetchNodes() async -> [Note] {
        //
        []
    }
    
    func addNode(_ note: Note) async {
        //
    }
    
    func updateNode(_ id: Int, title: String, description: String, isCompleted: Bool) async {
        //
    }
    
    func deleteNode(_ id: Int) async {
        //
    }
}
