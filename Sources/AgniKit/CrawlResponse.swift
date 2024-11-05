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
  
  /// Creates a new CrawlResponse instance
  /// - Parameters:
  ///   - jobId: Unique identifier for the crawl job
  ///   - startUrl: The starting URL for the crawl operation
  ///   - pages: Collection of pages discovered during crawling
  ///   - links: Collection of links between pages
  public init(jobId: String, startUrl: URL, pages: [CrawlPage], links: [CrawlLink]) {
    self.jobId = jobId
    self.startUrl = startUrl
    self.pages = pages
    self.links = links
  }
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
  
  /// Creates a new CrawlPage instance
  /// - Parameters:
  ///   - id: Unique identifier for the page
  ///   - url: URL of the page
  ///   - title: Title of the page
  ///   - depth: Depth level from the start URL
  ///   - status: HTTP status code from fetching the page
  public init(id: String, url: URL, title: String, depth: Int, status: Int) {
    self.id = id
    self.url = url
    self.title = title
    self.depth = depth
    self.status = status
  }
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
  
  /// Creates a new CrawlLink instance
  /// - Parameters:
  ///   - id: Unique identifier for the link
  ///   - sourceId: ID of the source page
  ///   - targetId: ID of the target page
  ///   - text: Link text content
  public init(id: String, sourceId: String, targetId: String, text: String) {
    self.id = id
    self.sourceId = sourceId
    self.targetId = targetId
    self.text = text
  }
} 