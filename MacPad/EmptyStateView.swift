//
//  EmptyStateView.swift
//  NotePad
//
//  Created by Mehadi Hasan on 31/7/25.
//


import SwiftUI

struct EmptyStateView: View {
    let onCreateNote: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Notes Yet")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Create your first note to get started")
                .foregroundColor(.secondary)
            
            Button("Create Note") {
                onCreateNote()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
