//
//  TabButtonWithClose.swift
//  NotePad
//
//  Created by Mehadi Hasan on 31/7/25.
//


import SwiftUI

struct TabButtonWithClose: View {
    let title: String
    let isSelected: Bool
    let onSelect: () -> Void
    let onClose: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: onSelect) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .primary : .secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Close button
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isHovering ? .primary : .secondary)
                    .frame(width: 12, height: 12)
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isHovering || isSelected ? 1.0 : 0.0)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color(NSColor.selectedControlColor) : Color.clear)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }
}
