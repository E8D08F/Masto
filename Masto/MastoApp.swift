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

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    
    @AppStorage("defaultInstance") var defaultInstance: String = ""
    @AppStorage("browser") var browser: String = "Safari"
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.windows.first?.performClose(nil)
        NSApp.servicesProvider = ServiceProvider()
        NSUpdateDynamicServices()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "arrowshape.zigzag.right", accessibilityDescription: nil)
        
        menu = NSMenu()
        menu.delegate = self
        
        statusItem.menu = menu
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        if defaultInstance.isEmpty {
            menu.addItem(withTitle: "Set Local Instance...",
                         action: #selector(openPreferences),
                         keyEquivalent: "")
        } else {
            menu.addItem(withTitle: "Follow on \(defaultInstance)...",
                         action: #selector(showOnInstance),
                         keyEquivalent: "")
        }
        menu.addItem(.separator())
        menu.addItem(withTitle: "Settings...", action: #selector(openPreferences), keyEquivalent: ",")
        menu.addItem(withTitle: "Quit \(NSApp.mainMenu!.items.first!.title)", action: #selector(quit), keyEquivalent: "q")
    }
    
    func menuDidClose(_ menu: NSMenu) {
        menu.removeAllItems()
    }
    
    @objc func showOnInstance() {
        Masto.followRemoteUser(on: defaultInstance, in: browser)
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

class ServiceProvider: NSObject {
    @objc func service(_ pasteboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        guard let handle = pasteboard.string(forType: .string) else { return }
        
        print(handle)
        
        let re = try! NSRegularExpression(pattern: #"@?([^@]+)@(.+)"#)
        let matches = re.matches(in: handle, range: NSRange(0..<handle.count))
        if let match = matches.first {
            let user = handle[Range(match.range(at: 1), in: handle)!]
            let host = handle[Range(match.range(at: 2), in: handle)!]
            
            if let url = URL(string: "https://\(host)/@\(user)") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
