import Foundation

/// An actor that interacts with the Firecrawl API.
///
/// This actor encapsulates the functionality to make authenticated requests to the Firecrawl API.
/// It handles API key management, request construction, and response parsing.
///
/// - Important: Ensure you have a valid API key before using this actor.
///
/// - Note: The Firecrawl API has rate limits. If exceeded, you will receive a 429 response code.
///
/// - SeeAlso: [Firecrawl API Documentation](https://api.firecrawl.dev)
public struct AgniKit {
  /// The base URL for all Firecrawl API requests.
  private let baseURL = URL(string: "https://api.firecrawl.dev")!
  
  /// The API key used for authentication.
  private let apiKey: String
  
  /// Initializes a new FirecrawlAPI actor.
  ///
  /// - Parameter apiKey: The API key for authenticating requests to the Firecrawl API.
  public init(apiKey: String) {
    self.apiKey = apiKey
  }
  
  /// Constructs an authenticated URLRequest for the Firecrawl API.
  ///
  /// - Parameter endpoint: The API endpoint to request.
  /// - Returns: A URLRequest configured with the appropriate headers and authentication.
  private func makeRequest(for endpoint: String) -> URLRequest {
    var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    return request
  }
  
  /// Scrapes a webpage using the Firecrawl API.
  ///
  /// This method sends a POST request to the Firecrawl API's scrape endpoint to extract content from a specified URL.
  ///
  /// - Parameters:
  ///   - url: The URL of the webpage to scrape.
  ///   - formats: An array of formats to include in the output. Default is ["markdown"].
  ///   - onlyMainContent: A boolean indicating whether to return only the main content of the page. Default is true.
  ///   - includeTags: An optional array of HTML tags to include in the output.
  ///   - excludeTags: An optional array of HTML tags to exclude from the output.
  ///   - headers: An optional dictionary of headers to send with the request.
  ///   - waitFor: An optional delay in milliseconds before fetching the content.
  ///   - timeout: An optional timeout in milliseconds for the request. Default is 30000.
  ///   - extract: An optional extraction configuration.
  ///   - actions: An optional array of actions to perform on the page before grabbing the content.
  ///
  /// - Returns: A dictionary containing the scraped data.
  ///
  /// - Throws: An error if the request fails or if the response cannot be decoded.
  public func scrape(
    url: String,
    formats: [String] = ["markdown"],
    onlyMainContent: Bool = true,
    includeTags: [String]? = nil,
    excludeTags: [String]? = nil,
    headers: [String: String]? = nil,
    waitFor: Int? = nil,
    timeout: Int = 30000,
    extract: [String: Any]? = nil,
    actions: [[String: Any]]? = nil
  ) async throws -> ScrapeResponse {
    var request = makeRequest(for: "v1/scrape")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    var body: [String: Any] = [
      "url": url,
      "formats": formats,
      "onlyMainContent": onlyMainContent,
      "timeout": timeout
    ]
    
    if let includeTags = includeTags { body["includeTags"] = includeTags }
    if let excludeTags = excludeTags { body["excludeTags"] = excludeTags }
    if let headers = headers { body["headers"] = headers }
    if let waitFor = waitFor { body["waitFor"] = waitFor }
    if let extract = extract { body["extract"] = extract }
    if let actions = actions { body["actions"] = actions }
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    let decoder = JSONDecoder()
    let scrapeResponse = try decoder.decode(ScrapeResponse.self, from: data)
    return scrapeResponse
  }
  
  /// Crawls a website using the Firecrawl API.
  ///
  /// This method sends a POST request to the Firecrawl API's crawl endpoint to crawl a specified URL and its linked pages.
  ///
  /// - Parameters:
  ///   - url: The base URL to start crawling from.
  ///   - excludePaths: An optional array of regex patterns to exclude from the crawl.
  ///   - includePaths: An optional array of regex patterns to include in the crawl.
  ///   - maxDepth: The maximum depth to crawl relative to the entered URL. Default is 2.
  ///   - ignoreSitemap: A boolean indicating whether to ignore the website sitemap when crawling. Default is true.
  ///   - limit: The maximum number of pages to crawl. Default is 10.
  ///   - allowBackwardLinks: A boolean indicating whether to enable navigation to previously linked pages. Default is false.
  ///   - allowExternalLinks: A boolean indicating whether to allow following links to external websites. Default is false.
  ///   - webhook: An optional URL to send webhook notifications about the crawl progress.
  ///   - scrapeOptions: An optional dictionary of scrape options to apply to each crawled page.
  ///
  /// - Returns: A dictionary containing the crawl job information, including the job ID and base URL.
  ///
  /// - Throws: An error if the request fails or if the response cannot be decoded.
  public func crawl(
    url: String,
    excludePaths: [String]? = nil,
    includePaths: [String]? = nil,
    maxDepth: Int = 2,
    ignoreSitemap: Bool = true,
    limit: Int = 10,
    allowBackwardLinks: Bool = false,
    allowExternalLinks: Bool = false,
    webhook: String? = nil,
    scrapeOptions: [String: Any]? = nil
  ) async throws -> [String: Any] {
    var request = makeRequest(for: "v1/crawl")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    var body: [String: Any] = [
      "url": url,
      "maxDepth": maxDepth,
      "ignoreSitemap": ignoreSitemap,
      "limit": limit,
      "allowBackwardLinks": allowBackwardLinks,
      "allowExternalLinks": allowExternalLinks
    ]
    
    if let excludePaths = excludePaths { body["excludePaths"] = excludePaths }
    if let includePaths = includePaths { body["includePaths"] = includePaths }
    if let webhook = webhook { body["webhook"] = webhook }
    if let scrapeOptions = scrapeOptions { body["scrapeOptions"] = scrapeOptions }
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let success = result["success"] as? Bool,
          success else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
    }
    
    return result
  }
  
  /// Retrieves the status of a crawl job using the Firecrawl API.
  ///
  /// This method sends a GET request to the Firecrawl API's crawl status endpoint to retrieve information about a specific crawl job.
  ///
  /// - Parameter id: The ID of the crawl job to retrieve status for.
  ///
  /// - Returns: A dictionary containing the crawl job status information.
  ///
  /// - Throws: An error if the request fails or if the response cannot be decoded.
  public func getCrawlStatus(id: String) async throws -> [String: Any] {
    let request = makeRequest(for: "v1/crawl/\(id)")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
    }
    
    return result
  }
  /// Cancels a crawl job using the Firecrawl API.
  ///
  /// This method sends a DELETE request to the Firecrawl API's crawl endpoint to cancel a specific crawl job.
  ///
  /// - Parameter id: The ID of the crawl job to cancel.
  ///
  /// - Returns: A dictionary containing the response information, including a success flag and a message.
  ///
  /// - Throws: An error if the request fails, if the response cannot be decoded, or if the server returns a non-200 status code.
  ///
  /// - Important: This operation is irreversible. Once a crawl job is cancelled, it cannot be resumed.
  ///
  /// - Note: If the crawl job has already completed or doesn't exist, the API may return a 404 error.
  public func cancelCrawl(id: String) async throws -> [String: Any] {
    var request = makeRequest(for: "v1/crawl/\(id)")
    request.httpMethod = "DELETE"
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let success = result["success"] as? Bool,
          success else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
    }
    
    return result
  }

  /// Maps a website using the Firecrawl API.
  ///
  /// This method sends a POST request to the Firecrawl API's map endpoint to crawl and map a website starting from a specified URL.
  ///
  /// - Parameters:
  ///   - url: The base URL to start crawling from.
  ///   - search: An optional search query to use for mapping. During the Alpha phase, the 'smart' part of the search functionality is limited to 1000 search results.
  ///   - ignoreSitemap: A boolean indicating whether to ignore the website sitemap when crawling. Default is true.
  ///   - includeSubdomains: A boolean indicating whether to include subdomains of the website. Default is false.
  ///   - limit: The maximum number of links to return. Default is 5000.
  ///
  /// - Returns: A dictionary containing the response information, including a success flag and an array of mapped links.
  ///
  /// - Throws: An error if the request fails, if the response cannot be decoded, or if the server returns a non-200 status code.
  ///
  /// - Important: The number of links returned may be limited by your API plan.
  ///
  /// - Note: If the 'search' parameter is provided, the API will attempt to find relevant pages within the crawled site.
  public func map(url: String, search: String? = nil, ignoreSitemap: Bool = true, includeSubdomains: Bool = false, limit: Int = 5000) async throws -> [String: Any] {
    var request = makeRequest(for: "v1/map")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = [
      "url": url,
      "search": search as Any,
      "ignoreSitemap": ignoreSitemap,
      "includeSubdomains": includeSubdomains,
      "limit": limit
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let success = result["success"] as? Bool,
          success,
          let links = result["links"] as? [String] else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
    }
    
    return result
  }

  /// Performs a synchronous batch scrape operation
  ///
  /// This method sends a POST request to scrape multiple URLs simultaneously and waits for all results.
  ///
  /// - Parameters:
  ///   - urls: Array of URLs to scrape
  ///   - formats: Array of desired output formats (e.g. ["markdown", "html"]). Default is ["markdown"]
  ///   - onlyMainContent: Whether to return only the main content. Default is true
  ///   - timeout: Timeout in milliseconds. Default is 30000
  ///
  /// - Returns: A BatchScrapeResponse containing all scraped results
  ///
  /// - Throws: An error if the request fails or if the response cannot be decoded
  public func batchScrape(
    urls: [String],
    formats: [String] = ["markdown"],
    onlyMainContent: Bool = true,
    timeout: Int = 30000
  ) async throws -> BatchScrapeResponse {
    var request = makeRequest(for: "v1/batch/scrape")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = [
      "urls": urls,
      "formats": formats,
      "onlyMainContent": onlyMainContent,
      "timeout": timeout
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, 
                   userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(BatchScrapeResponse.self, from: data)
  }
  
  /// Creates an asynchronous batch scrape job
  ///
  /// This method initiates a batch scrape job and returns immediately with a job ID
  ///
  /// - Parameters:
  ///   - urls: Array of URLs to scrape
  ///   - formats: Array of desired output formats (e.g. ["markdown", "html"]). Default is ["markdown"]
  ///   - onlyMainContent: Whether to return only the main content. Default is true
  ///
  /// - Returns: A BatchScrapeJobResponse containing the job ID and status URL
  ///
  /// - Throws: An error if the request fails or if the response cannot be decoded
  public func createBatchScrapeJob(
    urls: [String],
    formats: [String] = ["markdown"],
    onlyMainContent: Bool = true
  ) async throws -> BatchScrapeJobResponse {
    var request = makeRequest(for: "v1/batch/scrape")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = [
      "urls": urls,
      "formats": formats,
      "onlyMainContent": onlyMainContent,
      "async": true
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, 
                   userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    return try JSONDecoder().decode(BatchScrapeJobResponse.self, from: data)
  }
  
  /// Checks the status of an asynchronous batch scrape job
  ///
  /// - Parameter id: The job ID returned from createBatchScrapeJob
  ///
  /// - Returns: A BatchScrapeResponse containing the current status and any completed results
  ///
  /// - Throws: An error if the request fails or if the response cannot be decoded
  public func getBatchScrapeStatus(id: String) async throws -> BatchScrapeResponse {
    let request = makeRequest(for: "v1/batch/scrape/\(id)")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NSError(domain: "AgniKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NSError(domain: "AgniKit", code: httpResponse.statusCode, 
                   userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(BatchScrapeResponse.self, from: data)
  }
}