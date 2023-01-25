//
//  Masto.swift
//  Masto
//
//  Created by Toto Minai on 25/01/2023.
//

import AppKit

class Masto {
    static func getCurrentURL(in browser: String) -> URL? {
        
        let source = browser == "Safari" ?
            #"tell application "Safari" to return URL of front document"# :
            #"tell application "Google Chrome" to return URL of active tab of front window"#
        let script = NSAppleScript(source: source)!
        var error: NSDictionary?
        
        if let path = script.executeAndReturnError(&error).stringValue {
            return URL(string: path)
        }
        
        return nil
    }
    
    static func followRemoteUser(on instance: String, in browser: String) {
        if let currentURL = getCurrentURL(in: browser),
           let host = currentURL.host,
           host != instance,
           currentURL.pathComponents.count > 1 {
            let remoteHandle = "https://\(host)/\(currentURL.pathComponents[1])".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let remoteProfile = URL(string: "https://\(instance)/authorize_interaction/?uri=\(remoteHandle)")!
            NSWorkspace.shared.open(remoteProfile)
        }
    }
}
