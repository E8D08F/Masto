//
//  ContentView.swift
//  Masto
//
//  Created by Toto Minai on 25/01/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var window: NSWindow!
    @AppStorage("defaultInstance") var defaultInstance: String = ""
    @AppStorage("browser") var browser: String = "Safari"
    
    var body: some View {
        TabView {
            Form {
                TextField("Default Instance:",
                          text: $defaultInstance,
                          prompt: Text("mastodon.social"))
                
                Button("Set Current") {
                    if let currentURL = Masto.getCurrentURL(in: browser),
                       let host = currentURL.host {
                        defaultInstance = host
                    }
                }
                
                Picker("Browser", selection: $browser) {
                    Text("Safari").tag("Safari")
                    Text("Google Chrome").tag("Google Chrome")
                }
            }
            .padding()
            .tabItem { Label("General", systemImage: "gearshape") }
        }
        .frame(width: 312)
        .background(EffectView(.windowBackground, blendingMode: .behindWindow, window: $window))
        .onChange(of: window == nil) { _ in
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
        }
    }
}

struct EffectView: NSViewRepresentable {
    @Binding var window: NSWindow?
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    let followsWindowActiveState: Bool
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = followsWindowActiveState ? .followsWindowActiveState : .active
        
        DispatchQueue.main.async { self.window = view.window }
        
        return view
    }
    
    init(_ material: NSVisualEffectView.Material,
         blendingMode: NSVisualEffectView.BlendingMode,
         followsWindowActiveState: Bool = true,
         window: Binding<NSWindow?>) {
        self.material = material
        self.blendingMode = blendingMode
        self.followsWindowActiveState = followsWindowActiveState
        self._window = window
    }
    
    func updateNSView(_ view: NSVisualEffectView, context: Context) { }
}
