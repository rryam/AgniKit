import Foundation

/// A structure that defines the rules and constraints for web crawling.
///
/// `CrawlRules` encapsulates various parameters that control how the crawler
/// behaves when traversing web pages.
public struct CrawlRules {
  /// Paths to exclude from crawling
  public var excludePaths: [String]
  
  /// Paths to specifically include in crawling
  public var includePaths: [String]
  
  /// Maximum depth of page traversal from the starting URL
  public var maxDepth: Int
  
  /// Whether to ignore the site's sitemap.xml
  public var ignoreSitemap: Bool
  
  /// Whether to allow crawling links that point to previously visited pages
  public var allowBackwardLinks: Bool
  
  /// Whether to allow crawling links that point to external domains
  public var allowExternalLinks: Bool
  
  /// Creates a new instance with default crawling rules
  public init(
    excludePaths: [String] = [],
    includePaths: [String] = [],
    maxDepth: Int = 3,
    ignoreSitemap: Bool = false,
    allowBackwardLinks: Bool = false,
    allowExternalLinks: Bool = false
  ) {
    self.excludePaths = excludePaths
    self.includePaths = includePaths
    self.maxDepth = maxDepth
    self.ignoreSitemap = ignoreSitemap
    self.allowBackwardLinks = allowBackwardLinks
    self.allowExternalLinks = allowExternalLinks
  }
} 