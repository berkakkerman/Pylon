//
//  Poller.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

public actor Poller {
    
    private let client: PylonClient
    private let policy: RetryPolicy

    public init(client: PylonClient, policy: RetryPolicy = RetryPolicy()) {
        self.client = client
        self.policy = policy
    }

    /// Polls a `PylonRequest` until it succeeds or exhausting attempts.
    /// - Parameters:
    ///   - request: The request to execute (must be Sendable).
    ///   - validate: A @Sendable closure to verify if the response is acceptable.
    /// - Returns: The successful response.
    public func poll<T>(
        _ request: T,
        validate: @Sendable (T.Response) -> Bool
    ) async throws -> T.Response
    where T: PylonRequest & Sendable, T.Response: Sendable {
        var lastError: Error?

        for attempt in 0...policy.maxRetries {
            do {
                let response = try await client.send(request)
                if validate(response) {
                    return response
                }
            } catch {
                lastError = error
            }

            let delayInterval = policy.delay(for: attempt)
            try await Task.sleep(nanoseconds: UInt64(delayInterval * 1_000_000_000))
        }

        throw lastError ?? URLError(.cannotConnectToHost)
    }
}
