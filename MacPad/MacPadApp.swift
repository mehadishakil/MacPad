//
//  MacPadApp.swift
//  MacPad
//
//  Created by Mehadi Hasan on 31/7/25.
//

import SwiftUI

@main
struct MacPadApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(DefaultWindowStyle())
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Note") {
                    NotificationCenter.default.post(name: .createNewNote, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            
            CommandGroup(after: .newItem) {
                Button("Open Note...") {
                    NotificationCenter.default.post(name: .openNote, object: nil)
                }
                .keyboardShortcut("o", modifiers: .command)
                
                Button("Save Note") {
                    NotificationCenter.default.post(name: .saveNote, object: nil)
                }
                .keyboardShortcut("s", modifiers: .command)
            }
            
            CommandGroup(after: .textFormatting) {
                Button("Increase Font Size") {
                    NotificationCenter.default.post(name: .increaseFontSize, object: nil)
                }
                .keyboardShortcut("+", modifiers: .command)
                
                Button("Decrease Font Size") {
                    NotificationCenter.default.post(name: .decreaseFontSize, object: nil)
                }
                .keyboardShortcut("-", modifiers: .command)
                
                Button("Reset Font Size") {
                    NotificationCenter.default.post(name: .resetFontSize, object: nil)
                }
                .keyboardShortcut("0", modifiers: .command)
            }
        }
    }
}


extension Notification.Name {
    static let createNewNote = Notification.Name("createNewNote")
    static let openNote = Notification.Name("openNote")
    static let saveNote = Notification.Name("saveNote")
    static let increaseFontSize = Notification.Name("increaseFontSize")
    static let decreaseFontSize = Notification.Name("decreaseFontSize")
    static let resetFontSize = Notification.Name("resetFontSize")
}
