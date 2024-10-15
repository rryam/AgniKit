//
//  ScrapeResponse.swift
//  AgniKit
//
//  Created by Rudrank Riyam on 10/15/24.
//

import Foundation

/// A struct representing the response from the Firecrawl API's scrape endpoint.
public struct ScrapeResponse: Codable {
  /// Indicates whether the scrape operation was successful.
  public let success: Bool
  
  /// Contains the scraped data and associated information.
  public let data: ScrapeData
  
  /// A struct containing the detailed scraped data.
  public struct ScrapeData: Codable {
    /// The scraped content in Markdown format.
    public let markdown: String?
    
    /// The scraped content in HTML format.
    public let html: String?
    
    /// The raw HTML content of the scraped page.
    public let rawHtml: String?
    
    /// A base64-encoded screenshot of the scraped page.
    public let screenshot: String?
    
    /// An array of links found on the scraped page.
    public let links: [String]?
    
    /// Contains additional action-related data, such as screenshots taken during custom actions.
    public let actions: Actions?
    
    /// Metadata about the scraped page.
    public let metadata: Metadata
    
    /// Contains any extracted data using LLM (Language Model) processing.
    public let llmExtraction: [String: AnyCodable]?

    /// Any warning messages related to the scrape operation.
    public let warning: String?
    
    /// A struct representing action-related data.
    public struct Actions: Codable {
      /// An array of base64-encoded screenshots taken during custom actions.
      public let screenshots: [String]?
    }
    
    /// A struct containing metadata about the scraped page.
    public struct Metadata: Codable {
      /// The title of the scraped page.
      public let title: String?
      
      /// The description of the scraped page.
      public let description: String?
      
      /// The detected language of the scraped page.
      public let language: String?
      
      /// The source URL of the scraped page.
      public let sourceURL: String?
      
      /// The HTTP status code of the scrape request.
      public let statusCode: Int?
      
      /// Any error message associated with the scrape operation.
      public let error: String?
      
      /// Additional key-value pairs for any other metadata.
      public let additionalInfo: [String: String]?
      
      enum CodingKeys: String, CodingKey, CaseIterable {
        case title, description, language, sourceURL, statusCode, error
      }
      
      public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        
        let additionalContainer = try decoder.container(keyedBy: AnyCodingKey.self)
        var additionalDict = [String: String]()
        for key in additionalContainer.allKeys {
          if !CodingKeys.allCases.map({ $0.rawValue }).contains(key.stringValue) {
            if let value = try? additionalContainer.decode(String.self, forKey: key) {
              additionalDict[key.stringValue] = value
            }
          }
        }
        additionalInfo = additionalDict.isEmpty ? nil : additionalDict
      }
    }
    
    private enum CodingKeys: String, CodingKey {
      case markdown, html, rawHtml, screenshot, links, actions, metadata, llmExtraction = "llm_extraction", warning
    }
  }
}

/// A custom CodingKey that can represent any string key.
private struct AnyCodingKey: CodingKey {
  var stringValue: String
  var intValue: Int?
  
  init?(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }
  
  init?(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }
}

/// A struct that can decode and encode any JSON value.
///
/// This struct conforms to both `Codable` and `Decodable` protocols, allowing it to be used
/// for both encoding and decoding of JSON data. It can handle various types of JSON values
/// including integers, strings, booleans, doubles, arrays, and dictionaries.
public struct AnyCodable: Codable {
  let value: Any

  public init(_ value: Any) {
    self.value = value
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let int = try? container.decode(Int.self) {
      value = int
    } else if let string = try? container.decode(String.self) {
      value = string
    } else if let bool = try? container.decode(Bool.self) {
      value = bool
    } else if let double = try? container.decode(Double.self) {
      value = double
    } else if let array = try? container.decode([AnyCodable].self) {
      value = array.map { $0.value }
    } else if let dictionary = try? container.decode([String: AnyCodable].self) {
      value = dictionary.mapValues { $0.value }
    } else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JSON")
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch value {
    case let int as Int:
      try container.encode(int)
    case let string as String:
      try container.encode(string)
    case let bool as Bool:
      try container.encode(bool)
    case let double as Double:
      try container.encode(double)
    case let array as [Any]:
      try container.encode(array.map { AnyCodable($0) })
    case let dictionary as [String: Any]:
      try container.encode(dictionary.mapValues { AnyCodable($0) })
    default:
      throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid JSON"))
    }
  }
}
