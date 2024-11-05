import Testing
@testable import AgniKit
import Foundation

/// A test suite for the AgniKit module.
///
/// This suite contains tests for the functionality provided by the AgniKit module,
/// including tests for web scraping, crawling, and batch operations using the Swift Testing framework.
/// 
/// Based on unit testing best practices from [SwiftLee](https://www.avanderlee.com/swift/unit-tests-best-practices/)
@Suite struct AgniKitTests {
  
  /// A test case for web scraping functionality.
  ///
  /// This test demonstrates how to scrape a web page using AgniKit's scraping capabilities.
  /// It verifies that the scraped content contains expected elements from the Apple documentation.
  @Test("Scrape Apple's Defining Tests documentation")
  func testWebScraping() async throws {
    let agniKit = AgniKit(apiKey: "fc-4a967e2c76e34ca4809ebd606a9e2757")
    let url = "https://developer.apple.com/documentation/testing/definingtests"
    
    let scrapeResponse = try await agniKit.scrape(url: url)
    
    guard let markdown = scrapeResponse.data.markdown else {
      throw NSError(domain: "AgniKitTests", code: 1, userInfo: [NSLocalizedDescriptionKey: "Markdown content not found in the scraping result"])
    }
    
    #expect(markdown.contains("Defining test functions"))
    #expect(markdown.contains("Overview"))
    #expect(markdown.contains("Import the testing library"))
    #expect(markdown.contains("@Test"))
    
    #expect(scrapeResponse.success)
    #expect(scrapeResponse.data.metadata.sourceURL == url)
    #expect(scrapeResponse.data.metadata.statusCode == 200)
  }
  
  /// Tests batch scraping functionality with multiple URLs
  @Test("Batch scrape multiple documentation pages")
  func testBatchScraping() async throws {
    let agniKit = AgniKit(apiKey: "fc-4a967e2c76e34ca4809ebd606a9e2757")
    let urls = [
      "https://developer.apple.com/documentation/testing",
      "https://developer.apple.com/documentation/xctest"
    ]
    
    let response = try await agniKit.batchScrape(urls: urls)
    
    #expect(response.data.count == 2)
    #expect(response.data.allSatisfy { $0.metadata.statusCode == 200 })
    #expect(response.data.allSatisfy { $0.markdown != nil })
  }
  
  /// Tests website crawling functionality
  @Test("Crawl Apple's documentation site")
  func testCrawling() async throws {
    let agniKit = AgniKit(apiKey: "fc-4a967e2c76e34ca4809ebd606a9e2757")
    let url = "https://developer.apple.com/documentation/testing"
    
    let result = try await agniKit.crawl(
      url: url,
      maxDepth: 1,
      limit: 5
    )
    
    #expect(result["success"] as? Bool == true)
    #expect((result["links"] as? [String])?.isEmpty == false)
  }
  
  /// Tests website mapping functionality
  /// Tests website mapping functionality by mapping Apple's documentation site
  /// and verifying the returned links and success status
  ///
  /// This test:
  /// - Creates an AgniKit instance with test API key
  /// - Maps the Apple Testing documentation URL with a limit of 10 links
  /// - Verifies the response contains success=true and non-empty links array
  @Test("Map Apple's documentation site")
  func testMapping() async throws {
    let agniKit = AgniKit(apiKey: "fc-15d9574ec0a9482fa26a6b750aec14a9")
    let url = "https://developer.apple.com/documentation/testing"
    
    let result = try await agniKit.map(
      url: url,
      ignoreSitemap: true,
      includeSubdomains: false,
      limit: 10
    )
    
    guard let success = result["success"] as? Bool else {
      throw NSError(domain: "AgniKitTests", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing success field in response"])
    }
    
    guard let links = result["links"] as? [String] else {
      throw NSError(domain: "AgniKitTests", code: 2, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid links array in response"])
    }
    
    #expect(success)
    #expect(!links.isEmpty)
    #expect(links.count <= 10)
    #expect(links.allSatisfy { $0.starts(with: "https://developer.apple.com/") })
  }
}
