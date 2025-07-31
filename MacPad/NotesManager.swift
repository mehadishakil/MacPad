//
//  Note.swift
//  NotePad
//
//  Created by Mehadi Hasan on 31/7/25.
//


import Foundation

struct Note: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String = ""
    let createdAt = Date()
    
    init(title: String, content: String = "") {
        self.title = title
        self.content = content
    }
}


class NotesManager: ObservableObject {
    @Published var notes: [Note] = []
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func deleteNote(at index: Int) {
        guard index < notes.count else { return }
        notes.remove(at: index)
        saveNotes()
    }
    
    func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: notesKey)
        }
    }
    
    func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes
        }
    }
}
