//
//  MastoApp.swift
//  Masto
//
//  Created by Toto Minai on 25/01/2023.
//

import SwiftUI

@main
struct MastoApp: App {
    @NSApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        Settings { ContentView() }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    @AppStorage("defaultInstance") var defaultInstance: String = ""
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        NSApp.windows.first?.performClose(nil)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "arrowshape.zigzag.right", accessibilityDescription: nil)
        
        let menu = NSMenu()
        menu.addItem(withTitle: "Open Remote Profile...",
                     action: #selector(showOnInstance),
                     keyEquivalent: "")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Settings...", action: #selector(openPreferences), keyEquivalent: ",")
        menu.addItem(withTitle: "Quit \(NSApp.mainMenu!.items.first!.title)", action: #selector(quit), keyEquivalent: "q")
        
        statusItem.menu = menu
    }
    
    @objc func showOnInstance() {
        Masto.openProfile(on: defaultInstance)
    }
    
    @objc func quit() { NSApp.terminate(nil) }
    
    @objc func openPreferences() {
        if #available(macOS 13, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        NSApp.activate(ignoringOtherApps: true)
    }
}
