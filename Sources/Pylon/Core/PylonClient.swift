//
//  PylonClient.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

/// Main network client as an actor for Sendable safety
public actor PylonClient {
    
    private let session: URLSession
    private let config: PylonConfiguration

    public init(configuration: PylonConfiguration) {
        self.config = configuration
        self.session = URLSession(configuration: .default)
    }

    /// Sends a PylonRequest and decodes the response
    public func send<T: PylonRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try buildRequest(from: request)
        let (data, _) = try await session.data(for: urlRequest)
        return try JSONDecoder().decode(T.Response.self, from: data)
    }

    /// Cancels all in-flight URLSession tasks
    public func cancelAll() {
        session.invalidateAndCancel()
    }

    private func buildRequest<T: PylonRequest>(from request: T) throws -> URLRequest {
        guard var components = URLComponents(url: config.baseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        components.queryItems = request.queryItems
        guard let url = components.url else { throw URLError(.badURL) }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers ?? config.defaultHeaders
        urlRequest.httpBody = request.body
        urlRequest.timeoutInterval = config.timeout
        urlRequest.cachePolicy = request.cachePolicy
        return urlRequest
    }

    /// MARK: - Task API

    /// Send request with cancellable Task handle
    @discardableResult
    public func sendWithTask<T>(_ request: T) -> (task: Task<T.Response, Error>, id: UUID)
    where T: PylonRequest & Sendable, T.Response: Decodable & Sendable {
        let id = UUID()
        let requestCopy = request
        let task = Task<T.Response, Error> { [weak self] in
            guard let self else {
                throw URLError(.dataNotAllowed)
            }
            let response = try await self.send(requestCopy)
            return response
        }
        Task { await TaskManager.shared.register(task, for: id) }
        return (task, id)
    }

    /// Cancel specific in-flight request
    public func cancelRequest(id: UUID) async {
        await TaskManager.shared.cancel(id: id)
    }

    /// Cancel all in-flight requests
    public func cancelAllRequests() async {
        await TaskManager.shared.cancelAll()
    }
}
