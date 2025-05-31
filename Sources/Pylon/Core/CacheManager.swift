//
//  CacheManager.swift
//  Pylon
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

public actor CacheManager {
    public static let shared = CacheManager()
    private let cache: URLCache

    private init() {
        self.cache = URLCache(memoryCapacity: 20 * 1024 * 1024,
                               diskCapacity: 100 * 1024 * 1024,
                               diskPath: "pylon_cache")
        URLCache.shared = self.cache
    }

    public func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        cache.cachedResponse(for: request)
    }

    public func store(response: CachedURLResponse, for request: URLRequest) {
        cache.storeCachedResponse(response, for: request)
    }
}
