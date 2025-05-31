//
//  WebSocketEvent.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

/// Defines events received from WebSocket.
public enum WebSocketEvent {
    case text(String)
    case data(Data)
}
