//
//  NoteEditView.swift
//  NotePad
//
//  Created by Mehadi Hasan on 31/7/25.
//


import SwiftUI

struct NoteEditView: View {
    @Binding var note: Note
    let fontSize: CGFloat
    let onSave: () -> Void
    @State private var noteContent: String = ""
    
    var wordCount: Int {
        let words = noteContent.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        return words.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Note content editor
            TextEditor(text: $noteContent)
                .font(.system(size: fontSize))
                .textEditorStyle(.plain)
                .padding(16)
                .onChange(of: noteContent) { newValue in
                    note.content = newValue
                    onSave()
                }
            
            // Status bar with word count
            HStack {
                Spacer()
                Text("\(wordCount) words")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .background(Color(NSColor.controlBackgroundColor))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(NSColor.separatorColor)),
                alignment: .top
            )
        }
        .onAppear {
            noteContent = note.content
        }
        .onChange(of: note.content) { newContent in
            // Update local state when the note content changes externally
            if noteContent != newContent {
                noteContent = newContent
            }
        }
    }
}
