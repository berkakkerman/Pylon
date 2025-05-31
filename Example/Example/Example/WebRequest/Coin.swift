//
//  Coin.swift
//  PylonExample
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Foundation

struct Coin: Decodable, Identifiable, Sendable {
    
    let id: String
    let name: String
    let image: String
    let current_price: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case current_price = "current_price"
    }
}
