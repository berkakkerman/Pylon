//
//  TaskManager.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

public actor TaskManager {
    public static let shared = TaskManager()
    private var tasks: [UUID: any CancellableTask] = [:]

    private init() {}

    /// Register a Task.Handle with UUID
    public func register<Success, Failure>(_ task: Task<Success, Failure>, for id: UUID)
    where Success: Sendable, Failure: Sendable {
        tasks[id] = task
    }

    /// Cancel and remove a Task by UUID
    public func cancel(id: UUID) {
        if let task = tasks[id] {
            task.cancel()
        }
        tasks[id] = nil
    }

    /// Cancel all tasks
    public func cancelAll() {
        for id in tasks.keys {
            tasks[id]?.cancel()
        }
        tasks.removeAll()
    }
}
