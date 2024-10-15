# AgniKit: Unofficial Swift SDK for Firecrawl 🔥

AgniKit is the unofficial Swift SDK for the Firecrawl API. It provides a simple way to integrate Firecrawl's web scraping and crawling capabilities into your Swift projects for prototyping and development.

Agni (अग्नि) is the Sanskrit word for "fire", which aligns with the "fire" theme of Firecrawl. In Hindu mythology, Agni is also the god of fire, representing power and purification.

## Features

- One line Swift APIs for Firecrawl API
- Support for scraping, crawling, and data extraction
- Swift concurrency

## Installation

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/rryam/AgniKit.git", from: "1.0.0")
]
```

## Quick Start

```swift
import AgniKit

let agniKit = AgniKit(apiKey: "your-api-key")

do {
    let result = try await agniKit.scrape(url: "https://example.com")
    print(result.markdown)
} catch {
    print("Error: \(error)")
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

AgniKit is available under the MIT license. See the LICENSE file for more info.

---

AgniKit is not officially associated with Firecrawl. It is aimed for me to learn about its APIs and provide Swift developers easy access to Firecrawl's capabilities.
