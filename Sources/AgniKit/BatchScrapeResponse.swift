import Foundation

/// Represents the response from a batch scrape operation
public struct BatchScrapeResponse: Codable {
  /// The current status of the batch scrape job
  public let status: String
  
  /// Total number of URLs in the batch
  public let total: Int
  
  /// Number of completed URL scrapes
  public let completed: Int
  
  /// Number of API credits used for this operation
  public let creditsUsed: Int
  
  /// Timestamp when the results will expire
  public let expiresAt: Date
  
  /// Array of scraped results for each URL
  public let data: [BatchScrapeResult]
}

/// Represents the scraped result for a single URL in a batch
public struct BatchScrapeResult: Codable {
  /// The scraped content in markdown format (if requested)
  public let markdown: String?
  
  /// The scraped content in HTML format (if requested) 
  public let html: String?
  
  /// Metadata about the scraped page
  public let metadata: BatchScrapeMetadata
}

/// Metadata associated with a scraped page
public struct BatchScrapeMetadata: Codable {
  /// Title of the webpage
  public let title: String
  
  /// Detected language of the content
  public let language: String
  
  /// Original URL that was scraped
  public let sourceURL: String
  
  /// Meta description of the webpage
  public let description: String
  
  /// HTTP status code of the response
  public let statusCode: Int
}

/// Response for an asynchronous batch scrape job creation
public struct BatchScrapeJobResponse: Codable {
  /// Whether the job was successfully created
  public let success: Bool
  
  /// The unique identifier for the batch scrape job
  public let id: String
  
  /// URL to check the job status
  public let url: String
} 