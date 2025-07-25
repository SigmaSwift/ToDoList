//
//  RestNoteService.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

struct Note: Codable {
    let id: String
    let todo: String
    let completed: Bool
    let userId: Int
}

protocol NoteService {
    func getNotes(completion: @escaping ([Note]) -> Void)
}

class RestNoteService: NoteService {
    func getNotes(completion: @escaping ([Note]) -> Void) {
        completion([ Note(id: "01", todo: "Create sceleton!", completed: true, userId: 1) ])
    }
}
