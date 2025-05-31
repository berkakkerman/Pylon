//
//  DefaultWebSocketClient.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

/// DefaultWebSocketClient: A robust implementation using URLSessionWebSocketTask.
public final class DefaultWebSocketClient: WebSocketClient {
    
    // MARK: - Internal State
    
    private var task: URLSessionWebSocketTask?
    private let session: URLSession
    
    // Single AsyncThrowingStream and its continuation.
    private var continuation: AsyncThrowingStream<WebSocketEvent, Error>.Continuation?
    
    private lazy var eventStream: AsyncThrowingStream<WebSocketEvent, Error> = {
        AsyncThrowingStream { cont in
            // Store the continuation in a thread-safe manner.
            streamQueue.async(flags: .barrier) {
                self.continuation = cont
            }
        }
    }()
    
    /// The shared stream that external callers will listen to.
    public var stream: AsyncThrowingStream<WebSocketEvent, Error> {
        eventStream
    }
    
    // A concurrent queue to protect access to the continuation.
    private let streamQueue = DispatchQueue(
        label: "io.yourorg.DefaultWebSocketClient.streamQueue",
        attributes: .concurrent
    )
    
    private var isConnected = false
    
    
    // MARK: - Initialization
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    // MARK: - WebSocketClient Conformance
    
    /// Connects to a “wss://...” URL and starts listening for events.
    public func connect(to url: URL) async throws {
        // Prevent multiple concurrent connections.
        guard task == nil else {
            throw URLError(.cannotConnectToHost)
        }
        
        let request = URLRequest(url: url)
        let socketTask = session.webSocketTask(with: request)
        self.task = socketTask
        isConnected = true
        socketTask.resume()
        
        // Begin listening for incoming messages.
        listen()
    }
    
    /// Sends a text or binary message over the WebSocket.
    public func send(_ message: URLSessionWebSocketTask.Message) async throws {
        guard let task = self.task else {
            throw URLError(.badServerResponse)
        }
        try await task.send(message)
    }
    
    /// Disconnects the WebSocket, finishes the stream, and cancels the task.
    public func disconnect() async {
        isConnected = false
        
        // Finish the stream in a thread-safe manner.
        streamQueue.async(flags: .barrier) {
            self.continuation?.finish()
            self.continuation = nil
        }
        
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }
    
    /// Receives a single event from the shared stream.
    /// Throws if the stream finishes with an error or is closed.
    public func receive() async throws -> WebSocketEvent {
        for try await event in eventStream {
            return event
        }
        // If the stream has ended without events, throw a generic network error.
        throw URLError(.cannotLoadFromNetwork)
    }
    
    
    // MARK: - Private Listening Loop
    
    /// Recursively listens for messages via URLSessionWebSocketTask.receive.
    /// Yields incoming events or finishes the stream on error.
    private func listen() {
        guard isConnected, let task = self.task else { return }
        
        task.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                // On error, finish the stream with the thrown error.
                self.streamQueue.async(flags: .barrier) {
                    self.continuation?.finish(throwing: error)
                    self.continuation = nil
                }
                self.isConnected = false
                self.task = nil
                
            case .success(let message):
                // Convert the received URLSessionWebSocketTask.Message into WebSocketEvent.
                let event: WebSocketEvent = {
                    switch message {
                    case .data(let d): return .data(d)
                    case .string(let s): return .text(s)
                    @unknown default: return .text("")
                    }
                }()
                
                // Yield the event to the continuation in a thread-safe way.
                self.streamQueue.async {
                    self.continuation?.yield(event)
                }
                
                // Continue listening for the next message.
                self.listen()
            }
        }
    }
}
