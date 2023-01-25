//
//  Masto.swift
//  Masto
//
//  Created by Toto Minai on 25/01/2023.
//

import AppKit

class Masto {
    static func getCurrentURL() -> URL? {
        let source = #"tell application "Safari" to return URL of front document"#
        let script = NSAppleScript(source: source)!
        
        if let path = script.executeAndReturnError(nil).stringValue {
            return URL(string: path)
        }
        
        return nil
    }
    
    static func openProfile(on instance: String) {
        if let currentURL = getCurrentURL(),
           let host = currentURL.host,
           host != instance,
           currentURL.pathComponents.count > 1 {
            let remoteHandle = "\(currentURL.pathComponents[1])@\(host)"
            let remoteProfile = URL(string: "https://\(instance)/\(remoteHandle)")!
            NSWorkspace.shared.open(remoteProfile)
        }
    }
}
