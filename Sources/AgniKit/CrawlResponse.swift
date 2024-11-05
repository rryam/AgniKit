import Foundation

/// A structure representing the raw response from a web crawl operation.
///
/// This type contains the basic information returned by the crawling API before
/// being transformed into a more structured `CrawlMap`.
public struct CrawlResponse {
  /// Unique identifier for the crawl job
  public let jobId: String
  
  /// The starting URL for the crawl operation
  public let startUrl: URL
  
  /// Collection of pages discovered during crawling
  public let pages: [CrawlPage]
  
  /// Collection of links between pages
  public let links: [CrawlLink]
}

/// Raw page data from the crawl API response
public struct CrawlPage {
  /// Unique identifier for the page
  public let id: String
  
  /// URL of the page
  public let url: URL
  
  /// Title of the page
  public let title: String
  
  /// Depth level from the start URL
  public let depth: Int
  
  /// HTTP status code from fetching the page
  public let status: Int
}

/// Raw link data from the crawl API response
public struct CrawlLink {
  /// Unique identifier for the link
  public let id: String
  
  /// ID of the source page
  public let sourceId: String
  
  /// ID of the target page
  public let targetId: String
  
  /// Link text content
  public let text: String
} 