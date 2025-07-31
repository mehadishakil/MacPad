//
//  TabButton.swift
//  NotePad
//
//  Created by Mehadi Hasan on 31/7/25.
//


import SwiftUI

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? Color(NSColor.selectedControlColor) : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}