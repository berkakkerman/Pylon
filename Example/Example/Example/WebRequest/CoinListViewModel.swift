//
//  CoinListViewModel.swift
//  PylonExample
//
//  Created by Berk Akkerman on 30.05.2025.
//

import Pylon
import SwiftUI

@Observable
public final class CoinListViewModel {
    
    var coins: [Coin] = []
    
    private let client = PylonClient(configuration: .init(
        baseURL: URL(string: "https://api.coingecko.com/api/v3")!,
        timeout: 120
    ))

    @MainActor
    public func fetchCoins() async {
        do {
            let result: [Coin] = try await client.send(GetCoinsRequest())
            coins = result
        } catch {
            print("Error fetching coins: \(error)")
        }
    }
}
