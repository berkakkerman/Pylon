//
//  GetCoinsRequest.swift
//  PylonExample
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation
import Pylon

struct GetCoinsRequest: PylonRequest {
    var headers: [String : String]? = nil
    var body: Data? = nil

    typealias Response = [Coin]

    var path: String {
        return "/coins/markets"
    }

    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "vs_currency", value: "usd"),
            .init(name: "order", value: "market_cap_desc"),
            .init(name: "per_page", value: "10"),
            .init(name: "page", value: "1"),
            .init(name: "sparkline", value: "false")
        ]
    }

    var method: HTTPMethod {
        return .get
    }

    var cachePolicy: URLRequest.CachePolicy {
        .reloadIgnoringLocalCacheData
    }
}
