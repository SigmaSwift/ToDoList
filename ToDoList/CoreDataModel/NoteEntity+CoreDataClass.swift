//
//  NoteEntity+CoreDataClass.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 29.07.25.
//
//

import Foundation
import CoreData

@objc(NoteEntity)
public class NoteEntity: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var date: Date?
    @NSManaged public var completed: Bool
}

extension NoteEntity: Identifiable { }
