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
/// - See also: [Firecrawl API Documentation](https://api.firecrawl.dev)
public actor AgniKit {
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
  
  // Add methods for specific API endpoints here
}
