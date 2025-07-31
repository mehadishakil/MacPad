//
//  ContentView.swift
//  NotePad
//
//  Created by Mehadi Hasan on 31/7/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var notesManager = NotesManager()
    @State private var selectedTabIndex = 0
    @State private var showingNewNoteAlert = false
    @State private var newNoteTitle = ""
    @State private var fontSize: CGFloat = 14
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with tabs
            HStack {
                // Tab buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2) {
                        ForEach(Array(notesManager.notes.enumerated()), id: \.offset) { index, note in
                            TabButtonWithClose(
                                title: note.title,
                                isSelected: selectedTabIndex == index,
                                onSelect: { selectedTabIndex = index },
                                onClose: { closeTab(at: index) }
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                }
                
                Spacer()
                
                // Font size controls
                HStack(spacing: 4) {
                    Button(action: decreaseFontSize) {
                        Image(systemName: "textformat.size.smaller")
                            .foregroundColor(.secondary)
                            .font(.system(size: 12))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("Decrease font size (⌘-)")
                    
                    Text("\(Int(fontSize))")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                        .frame(minWidth: 20)
                    
                    Button(action: increaseFontSize) {
                        Image(systemName: "textformat.size.larger")
                            .foregroundColor(.secondary)
                            .font(.system(size: 12))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("Increase font size (⌘+)")
                }
                .padding(.trailing, 8)
                
                // New note button
                Button(action: createNewNote) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 12)
            }
            .frame(height: 40)
            .background(Color(NSColor.controlBackgroundColor))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(NSColor.separatorColor)),
                alignment: .bottom
            )
            
            // Main content area
            if notesManager.notes.isEmpty {
                EmptyStateView {
                    createNewNote()
                }
            } else if selectedTabIndex < notesManager.notes.count {
                NoteEditView(
                    note: $notesManager.notes[selectedTabIndex],
                    fontSize: fontSize,
                    onSave: { notesManager.saveNotes() }
                )
                .id(notesManager.notes[selectedTabIndex].id) // Force view refresh when note changes
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            notesManager.loadNotes()
            if !notesManager.notes.isEmpty && selectedTabIndex >= notesManager.notes.count {
                selectedTabIndex = 0
            }
            loadFontSize()
        }
        .onReceive(NotificationCenter.default.publisher(for: .createNewNote)) { _ in
            createNewNote()
        }
        .onReceive(NotificationCenter.default.publisher(for: .openNote)) { _ in
            openNoteFromFile()
        }
        .onReceive(NotificationCenter.default.publisher(for: .saveNote)) { _ in
            saveCurrentNoteToFile()
        }
        .onReceive(NotificationCenter.default.publisher(for: .increaseFontSize)) { _ in
            increaseFontSize()
        }
        .onReceive(NotificationCenter.default.publisher(for: .decreaseFontSize)) { _ in
            decreaseFontSize()
        }
        .onReceive(NotificationCenter.default.publisher(for: .resetFontSize)) { _ in
            resetFontSize()
        }
        .alert("New Note", isPresented: $showingNewNoteAlert) {
            TextField("Note title", text: $newNoteTitle)
            Button("Cancel") { }
            Button("Create") {
                if !newNoteTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let newNote = Note(title: newNoteTitle.trimmingCharacters(in: .whitespacesAndNewlines))
                    notesManager.addNote(newNote)
                    selectedTabIndex = notesManager.notes.count - 1
                }
            }
        } message: {
            Text("Enter a title for your new note")
        }
    }
    
    private func createNewNote() {
        newNoteTitle = ""
        showingNewNoteAlert = true
    }
    
    private func closeTab(at index: Int) {
        guard index >= 0 && index < notesManager.notes.count else { return }
        
        // Adjust selectedTabIndex before removing the note
        if notesManager.notes.count == 1 {
            // If this is the last tab, reset to 0
            selectedTabIndex = 0
        } else if index == selectedTabIndex {
            // If closing the selected tab
            if selectedTabIndex == notesManager.notes.count - 1 {
                // If it's the last tab, select the previous one
                selectedTabIndex = max(0, selectedTabIndex - 1)
            }
            // If it's not the last tab, selectedTabIndex stays the same (next tab will shift into this position)
        } else if index < selectedTabIndex {
            // If closing a tab before the selected one, adjust the index
            selectedTabIndex -= 1
        }
        
        // Remove the note
        notesManager.deleteNote(at: index)
        
        // Ensure selectedTabIndex is within bounds
        if selectedTabIndex >= notesManager.notes.count {
            selectedTabIndex = max(0, notesManager.notes.count - 1)
        }
    }
    
    private func increaseFontSize() {
        if fontSize < 36 {
            fontSize += 1
            saveFontSize()
        }
    }
    
    private func decreaseFontSize() {
        if fontSize > 8 {
            fontSize -= 1
            saveFontSize()
        }
    }
    
    private func resetFontSize() {
        fontSize = 14
        saveFontSize()
    }
    
    private func saveFontSize() {
        UserDefaults.standard.set(fontSize, forKey: "fontSize")
    }
    
    private func loadFontSize() {
        let savedFontSize = UserDefaults.standard.double(forKey: "fontSize")
        if savedFontSize > 0 {
            fontSize = CGFloat(savedFontSize)
        }
    }
    
    private func openNoteFromFile() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["txt", "text"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                let fileName = url.deletingPathExtension().lastPathComponent
                let newNote = Note(title: fileName, content: content)
                notesManager.addNote(newNote)
                selectedTabIndex = notesManager.notes.count - 1
            } catch {
                // Handle error silently for minimal app
                print("Error opening file: \(error)")
            }
        }
    }
    
    private func saveCurrentNoteToFile() {
        guard selectedTabIndex < notesManager.notes.count else { return }
        
        let currentNote = notesManager.notes[selectedTabIndex]
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["txt"]
        panel.nameFieldStringValue = "\(currentNote.title).txt"
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                try currentNote.content.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                // Handle error silently for minimal app
                print("Error saving file: \(error)")
            }
        }
    }
}


#Preview {
    ContentView()
}
