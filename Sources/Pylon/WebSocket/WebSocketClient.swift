//
//  WebSocketClient.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

/// Protocol defining a basic WebSocket client interface.
public protocol WebSocketClient {
    /// Connects to the given WebSocket URL.
    func connect(to url: URL) async throws
    
    /// Sends a message over the WebSocket.
    func send(_ message: URLSessionWebSocketTask.Message) async throws
    
    /// Disconnects the WebSocket connection.
    func disconnect() async
    
    /// Receives the next event (text or data) from the WebSocket.
    func receive() async throws -> WebSocketEvent
    
    /// Provides a stream of all WebSocket events with error propagation.
    var stream: AsyncThrowingStream<WebSocketEvent, Error> { get }
}
