# 🛰️ Pylon

**Pylon** is a lightweight, `async/await`-driven Swift networking package built with modern Swift concurrency and clean architectural principles. It abstracts away low-level `URLSession` boilerplate and offers a powerful, actor-based client for safe and scalable networking.

> ✅ **Supports iOS 13 and above**

---

## ✨ Features

- ✅ `async/await` native API
- ✅ `Sendable`-safe with `actor`-based isolation
- ✅ Fully typed, protocol-oriented request building
- ✅ Configurable base URL, headers, and timeouts
- ✅ Request cancellation & task tracking
- ✅ Cancellable tasks with UUID handles
- ✅ Optional caching, retry, polling
- ✅ WebSocket support
- ✅ Minimal, dependency-free
- ✅ iOS **13+** support

---

## 📦 Installation

### Swift Package Manager

In Xcode:

1. Go to **File > Add Packages**
2. Use the URL: `https://github.com/yourusername/Pylon.git`

Or in `Package.swift`:

```swift
.package(url: "https://github.com/yourusername/Pylon.git", brach: "main")
```

# Network Call

## Creating Request

```swift
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
```

## Creating Client

```swift
 private let client = PylonClient(configuration: .init(
        baseURL: URL(string: "https://api.coingecko.com/api/v3")!,
        timeout: 120
 ))
```

## Making the call

```swift
    do {
        let result: [Coin] = try await client.send(GetCoinsRequest())
        coins = result
    } catch {
        print("Error fetching coins: \(error)")
    }
```

# Web Socket

## Connect

```swift
    let webSocketClient: WebSocketClient = DefaultWebSocketClient()
    let url: URL { URL(string: "wss://echo.websocket.org")! }
    
    Task {
        do {
            try await webSocketClient.connect(to: url)
            await startListening()
        } catch {
            print("WebSocket connect error: \(error)")
        }
    }
```

## Listen

```swift
    do {
        for try await event in webSocketClient.stream {
            switch event {
            case .text(let text):
                messages.append(text)
            case .data:
                break
            }
        }
    } catch {
        print("WebSocket receive error: \(error)")
    }
    
```

## Send

```swift
   Task {
        do {
            try await webSocketClient.send(.string(text))
        } catch {
            print("WebSocket send error: \(error)")
        }
   }  
```

## Disconnect

```swift
    Task {
        await webSocketClient.disconnect()
    }    
```

# 🤝 Contributing
Contributions, suggestions, and feedback are welcome! Open an issue or submit a PR 🙌

# 📄 License
Pylon is released under the MIT License.
