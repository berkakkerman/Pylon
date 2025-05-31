//
//  PylonRequest.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

public protocol PylonRequest {
    associatedtype Response: Decodable

    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}
