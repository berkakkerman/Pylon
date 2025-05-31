//
//  EchoView.swift
//  PylonExample
//
//  Created by Berk Akkerman on 30.05.2025.
//

import SwiftUI

struct EchoView: View {
    
    @State private var viewModel = EchoViewModel()
    @State private var input: String = "PYLON IS COOL"

    var body: some View {
        VStack {
            List(viewModel.messages, id: \.self) { msg in
                Text(msg)
            }
            HStack {
                TextField("Message", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.send(input)
                    input = ""
                }
                .disabled(input.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Echo Web Socket")
        .onAppear { viewModel.connect() }
        .onDisappear { viewModel.disconnect() }
    }
}

#Preview {
    EchoView()
}
