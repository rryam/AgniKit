import Foundation
import AgniKit

/// A structure representing the results of a web crawl operation.
///
/// `CrawlMap` contains information about the pages visited during crawling
/// and their relationships to each other.
public struct CrawlMap {
  /// Unique identifier for the crawl job
  public let jobId: String
  
  /// The root URL where crawling started
  public let rootURL: URL
  
  /// Collection of pages discovered during crawling
  public let pages: [CrawlPage]
  
  /// Collection of links between pages
  public let links: [CrawlLink]
  
  /// Creates a new instance from an API response
  public init(from response: CrawlResponse) {
    self.jobId = response.jobId
    self.rootURL = response.startUrl
    self.pages = response.pages.map { CrawlPage(from: $0) }
    self.links = response.links.map { CrawlLink(from: $0) }
  }
}

/// Represents a single page discovered during crawling
public struct CrawlPage: Identifiable {
  public let id: String
  public let url: URL
  public let title: String
  public let depth: Int
  public let status: Int
  
  init(from apiPage: CrawlPage) {
    self.id = apiPage.id
    self.url = apiPage.url
    self.title = apiPage.title
    self.depth = apiPage.depth
    self.status = apiPage.status
  }
}

/// Represents a link between two pages
public struct CrawlLink: Identifiable {
  public let id: String
  public let sourceId: String
  public let targetId: String
  public let text: String
  
  init(from apiLink: CrawlLink) {
    self.id = apiLink.id
    self.sourceId = apiLink.sourceId
    self.targetId = apiLink.targetId
    self.text = apiLink.text
  }
} 
