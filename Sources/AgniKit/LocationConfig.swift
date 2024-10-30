/// Configuration for location and language settings
///
/// Used to specify geographic and linguistic preferences for API requests.
public struct LocationConfig: Encodable {
  /// The target country code (ISO 3166-1 alpha-2)
  public let country: CountryCode
  
  /// Preferred languages in order of priority
  public let languages: [String]?
  
  /// Creates a new location configuration
  /// - Parameters:
  ///   - country: The target country code
  ///   - languages: Optional array of language codes (e.g., ["en-US", "es"])
  public init(country: CountryCode, languages: [String]? = nil) {
    self.country = country
    self.languages = languages
  }
}