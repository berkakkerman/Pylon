//
//  ContentView.swift
//  PylonExample
//
//  Created by Berk Akkerman on 30.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        List {
            NavigationLink("Web Request", destination: CoinListView())
            NavigationLink("Web Socket", destination: EchoView())
        }
        .navigationTitle("Pylon Examples")
    }
    
}

#Preview {
    ContentView()
}
