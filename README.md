# AgniKit 🔥

AgniKit is the unofficial Swift SDK for the Firecrawl API. It provides a simple and efficient way to integrate Firecrawl's web scraping and crawling capabilities into your Swift projects.

## 🌟 Features

- Easy-to-use Swift interface for Firecrawl API
- Support for scraping, crawling, and data extraction
- Asynchronous operations using Swift concurrency
- Comprehensive error handling

## 📦 Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AgniKit.git", from: "1.0.0")
]
```

## 🚀 Quick Start

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

## 📘 Documentation

For detailed documentation and usage examples, please visit our [wiki](https://github.com/yourusername/AgniKit/wiki).

## 🔥 Why "AgniKit"?

The name "AgniKit" combines two elements:

1. "Agni" (अग्नि): This is the Sanskrit word for "fire", which aligns perfectly with the "fire" theme of Firecrawl. In Hindu mythology, Agni is also the god of fire, representing transformative power and purification.

2. "Kit": This suffix is commonly used in Swift development to denote a collection of tools or a framework, making it instantly recognizable to Swift developers.

By combining these elements, "AgniKit" captures the essence of Firecrawl's powerful web scraping capabilities while presenting it in a form familiar to the Swift ecosystem.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

AgniKit is available under the MIT license. See the LICENSE file for more info.

## 📬 Contact

For any inquiries or issues, please open an issue on this GitHub repository.

---

AgniKit is not officially associated with Firecrawl. It is a community-driven project aimed at providing Swift developers easy access to Firecrawl's capabilities.
