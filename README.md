# **AgniKit: Unofficial Swift SDK for Firecrawl 🔥**

AgniKit is the unofficial Swift SDK for the [Firecrawl](https://www.firecrawl.dev) API. It provides a simple way to integrate Firecrawl's web scraping and crawling capabilities into your Swift projects for prototyping and development.

Agni (अग्नि) is the Sanskrit word for "fire", which aligns with the "fire" theme of Firecrawl. In Hindu mythology, Agni is also the god of fire, representing power and purification.

## **Quickstart**

Find the quickstart of Firecrawl here: [Quickstart](https://docs.firecrawl.dev/introduction)

## **Features**

- One line Swift APIs for Firecrawl API
- Support for scraping, crawling, and data extraction
- Swift concurrency

## **Installation**

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/rryam/AgniKit.git", from: "1.0.0")
]
```

## **Quick Start**

```swift
import AgniKit

let agniKit = AgniKit(apiKey: "your-api-key")

do {
    let result = try await agniKit.scrape(url: "https://example.com")
    print(result)
} catch {
    print("Error: \(error)")
}
```

## **Examples**

### Scraping a webpage

```swift
let result = try await agniKit.scrape(
    url: "https://example.com",
    formats: ["markdown", "html"],
    onlyMainContent: true,
    includeTags: ["p", "h1", "h2"],
    excludeTags: ["script", "style"],
    timeout: 60000
)
print(result)
```

### Crawling a website

```swift
let crawlJob = try await agniKit.crawl(
    url: "https://example.com",
    maxDepth: 3,
    limit: 100,
    allowExternalLinks: false,
    scrapeOptions: ["formats": ["markdown"]]
)
print("Crawl job started: \(crawlJob)")

// Check crawl status
let status = try await agniKit.getCrawlStatus(id: crawlJob["id"] as! String)
print("Crawl status: \(status)")
```

### Mapping a website

```swift
let mapResult = try await agniKit.map(
    url: "https://example.com",
    search: "product",
    includeSubdomains: true,
    limit: 1000
)
print("Mapped links: \(mapResult["links"] as! [String])")
```

### Canceling a crawl job

```swift
let cancelResult = try await agniKit.cancelCrawl(id: "crawl-job-id")
print("Crawl job canceled: \(cancelResult)")
```

## **Contributing**

Contributions are welcome! Please feel free to submit a Pull Request.

## **License**

AgniKit is available under the MIT license. See the LICENSE file for more info.

---

AgniKit is not officially associated with Firecrawl. It is aimed for me to learn about its APIs and provide Swift developers easy access to Firecrawl's capabilities.
