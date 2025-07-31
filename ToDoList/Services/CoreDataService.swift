//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 27.07.25.
//

import CoreData
import UIKit

final class CoreDataManager: ICoreDataManager {
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    func fetchNotes() throws -> [Note] {
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        let results = try context.fetch(fetchRequest)
        return results.map { entity in
            Note(
                id: Int(entity.id),
                title: entity.title,
                todo: entity.todo ?? "fstan",
                completed: entity.completed,
                userId: Int(entity.userId)
            )
        }
    }
    
    func save(notes: [Note]) throws {
        for note in notes {
            let noteEntity = NoteEntity(context: context)
            noteEntity.id = Int64(note.id)
            noteEntity.title = note.title
            noteEntity.todo = note.todo
            noteEntity.completed = note.completed
            noteEntity.userId = Int64(note.userId)
            noteEntity.date = Date.now // need to fix
        }
        try context.save()
    }
    
    func save(note: Note) throws {
        let noteEntity = NoteEntity(context: context)
        noteEntity.id = Int64(note.id)
        noteEntity.title = note.title
        noteEntity.todo = note.todo
        noteEntity.completed = note.completed
        noteEntity.userId = Int64(note.userId)
        noteEntity.date = Date.now // need to fix
        try context.save()
    }
    
    func updateNote(with id: Int, title: String, description: String, isCompleted: Bool) throws {
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        let results = try context.fetch(fetchRequest)
        
        guard let noteEntity = results.first else { return }
        
        noteEntity.title = title
        noteEntity.todo = description
        noteEntity.completed = isCompleted
        noteEntity.date = Date.now
        try context.save()
    }
    
    func deleteNote(with id: Int) throws {
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let results = try context.fetch(fetchRequest)
        results.forEach { context.delete($0) }
        try context.save()
    }
}
