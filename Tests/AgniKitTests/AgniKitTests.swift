import Testing
@testable import AgniKit
import Foundation

/// A test suite for the AgniKit module.
///
/// This suite contains tests for the functionality provided by the AgniKit module,
/// including a test for web scraping capabilities using the new Swift Testing framework.
@Suite struct AgniKitTests {
  
  /// A test case for web scraping functionality.
  ///
  /// This test demonstrates how to scrape a web page using AgniKit's scraping capabilities.
  /// It verifies that the scraped content contains expected elements from the Apple documentation.
  @Test("Scrape Apple's Defining Tests documentation")
  func testWebScraping() async throws {
    let agniKit = AgniKit(apiKey: "fc-")
    
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
}
