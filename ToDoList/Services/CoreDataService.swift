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
                userId: Int(entity.userId),
                date: entity.date?.toString()
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
            noteEntity.date = note.date?.toDate()
        }
        try context.save()
    }
    
    func save(_ note: Note) throws {
        let noteEntity = NoteEntity(context: context)
        noteEntity.id = Int64(note.id)
        noteEntity.title = note.title
        noteEntity.todo = note.todo
        noteEntity.completed = note.completed
        noteEntity.userId = Int64(note.userId)
        noteEntity.date = Date.now
        
        try context.save()
    }
    
    func update(_ note: Note) throws {
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", note.id)
        
        if let noteEntity = try context.fetch(fetchRequest).first {
            noteEntity.title = note.title
            noteEntity.todo = note.todo
            noteEntity.completed = note.completed
            try context.save()
        }
    }
    
    func deleteNote(with id: Int) throws {
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        let results = try context.fetch(fetchRequest)
        results.forEach { context.delete($0) }
        try context.save()
    }
}


extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.date(from: self)
    }
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
}
