//
//  CoinListView.swift
//  PylonExample
//
//  Created by Berk Akkerman on 30.05.2025.
//

import SwiftUI

struct CoinListView: View {
    @State private var viewModel = CoinListViewModel()

    var body: some View {
        List(viewModel.coins) { coin in
            HStack {
                AsyncImage(url: URL(string: coin.image)) { image in
                    image.resizable().frame(width: 32, height: 32)
                } placeholder: {
                    ProgressView()
                }
                VStack(alignment: .leading) {
                    Text(coin.name).font(.headline)
                    Text("$\(coin.current_price, specifier: "%.2f")").font(.subheadline)
                }
            }
        }
        .navigationTitle("Coins")
        .task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await viewModel.fetchCoins()
        }
    }
}

#Preview {
    CoinListView()
}
