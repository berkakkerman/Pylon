//
//  EchoViewModel.swift
//  PylonExample
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Pylon
import SwiftUI

@available(iOS 17.0, *)
@Observable
public final class EchoViewModel {
    
    public var messages: [String] = []
    private let webSocketClient: WebSocketClient = DefaultWebSocketClient()
    private var url: URL { URL(string: "wss://echo.websocket.org")! }

    public func connect() {
        Task {
            do {
                try await webSocketClient.connect(to: url)
                await startListening()
            } catch {
                print("WebSocket connect error: \(error)")
            }
        }
    }

    public func send(_ text: String) {
        Task {
            do {
                try await webSocketClient.send(.string(text))
            } catch {
                print("WebSocket send error: \(error)")
            }
        }
    }

    @MainActor
    private func startListening() async {
        do {
            for try await event in webSocketClient.stream {
                switch event {
                case .text(let text):
                    messages.append(text)
                case .data:
                    break
                }
            }
        } catch {
            print("WebSocket receive error: \(error)")
        }
    }

    public func disconnect() {
        Task {
            await webSocketClient.disconnect()
        }
    }
}
