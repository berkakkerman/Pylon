//
//  CancellableTask.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

/// Type-erased cancellable task protocol
public protocol CancellableTask: Sendable {
    func cancel()
}

/// Make Swift Concurrency Task conform to CancellableTask when responses are Sendable
extension Task: CancellableTask where Success: Sendable, Failure: Sendable {}
