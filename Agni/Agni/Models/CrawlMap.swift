import Foundation
import AgniKit

/// A structure representing the results of a web crawl operation.
///
/// The `CrawlMap` structure provides a structured representation of crawled web pages
/// and their relationships. It contains information about pages visited during crawling
/// and the links between them.
///
/// - Important: This structure is immutable and thread-safe.
///
/// - Note: The map is constructed from a `CrawlResponse` which contains the raw data
///         from the crawling operation.
public struct CrawlMap {
  /// Unique identifier for the crawl job.
  ///
  /// This identifier can be used to track or reference specific crawl operations.
  public let jobId: String
  
  /// The root URL where crawling started.
  ///
  /// This URL serves as the entry point for the crawl operation and
  /// all other pages are discovered relative to this starting point.
  public let rootURL: URL
  
  /// Collection of pages discovered during crawling.
  ///
  /// An array of `CrawlPage` objects representing each unique page
  /// that was successfully crawled.
  public let pages: [CrawlPage]
  
  /// Collection of links between pages.
  ///
  /// An array of `CrawlLink` objects representing the relationships
  /// between crawled pages.
  public let links: [CrawlLink]
  
  /// Creates a new instance from an API response.
  ///
  /// - Parameter response: A `CrawlResponse` containing the raw crawl data.
  ///
  /// - Note: This initializer transforms the raw response data into a more
  ///         structured representation.
  public init(from response: CrawlResponse) {
    self.jobId = response.jobId
    self.rootURL = response.startUrl
    self.pages = response.pages
    self.links = response.links
  }
}
