//
//  RetryPolicy.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

/// Defines how retries should behave, with exponential backoff and optional jitter.
public struct RetryPolicy {
    public let maxRetries: Int
    public let baseDelay: TimeInterval // in seconds
    public let maxDelay: TimeInterval  // upper bound for backoff
    public let jitter: Bool            // whether to apply random jitter

    public init(maxRetries: Int = 3,
                baseDelay: TimeInterval = 1.0,
                maxDelay: TimeInterval = 30.0,
                jitter: Bool = true) {
        self.maxRetries = maxRetries
        self.baseDelay = baseDelay
        self.maxDelay = maxDelay
        self.jitter = jitter
    }

    /// Calculates delay for a given attempt (0-based).
    func delay(for attempt: Int) -> TimeInterval {
        let exponential = min(maxDelay, baseDelay * pow(2.0, Double(attempt)))
        guard jitter else { return exponential }
        let randomFactor = Double.random(in: 0.5...1.5)
        return exponential * randomFactor
    }
}
