//
//  PylonConfiguration.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

public struct PylonConfiguration {
    public let baseURL: URL
    public let timeout: TimeInterval
    public let defaultHeaders: [String: String]

    public init(baseURL: URL,
                timeout: TimeInterval = 30,
                defaultHeaders: [String: String] = [:]) {
        self.baseURL = baseURL
        self.timeout = timeout
        self.defaultHeaders = defaultHeaders
    }
}
