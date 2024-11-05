import SwiftUI
import AgniKit

/// A view that provides a user interface for web crawling functionality.
///
/// The `CrawlerView` allows users to:
/// - Enter a starting URL for crawling
/// - Configure crawling parameters like maximum pages and rules
/// - Visualize the crawl results in real time
/// - Monitor crawling progress
///
/// ## Overview
/// This view is split into two main sections:
/// - A configuration form on the left
/// - A visualization of the crawl map on the right
struct CrawlerView: View {
  // MARK: - State Properties
  
  /// The starting URL for the crawl operation
  @State private var startURL = ""
  
  /// Maximum number of pages to crawl
  @State private var maxPages = 10
  
  /// Rules that define crawling behavior
  @State private var crawlRules = CrawlRules()
  
  /// The resulting map from the crawl operation
  @State private var crawlMap: CrawlMap?
  
  /// Indicates whether a crawl is currently in progress
  @State private var isCrawling = false
  
  /// Any error that occurred during crawling
  @State private var crawlError: Error?
  
  // MARK: - Private Properties
  
  private let agniKit = AgniKit(apiKey: "your-api-key-here")
  
  // MARK: - Body
  
  var body: some View {
    VStack {
      Form {
        TextField("Start URL", text: $startURL)
          .textFieldStyle(.roundedBorder)
          .disabled(isCrawling)
        
        Stepper("Max Pages: \(maxPages)", value: $maxPages, in: 1...100)
          .disabled(isCrawling)
        
        CrawlRulesEditor(rules: $crawlRules)
          .disabled(isCrawling)
        
        Button(isCrawling ? "Cancel Crawl" : "Start Crawling") {
          Task {
            if isCrawling {
              await cancelCrawl()
            } else {
              await startCrawl()
            }
          }
        }
        .disabled(startURL.isEmpty)
        
        if isCrawling {
          ProgressView()
            .progressViewStyle(.circular)
        }
        
        if let error = crawlError {
          Text(error.localizedDescription)
            .foregroundColor(.red)
        }
      }
      .padding()
      
      if let crawlMap = crawlMap {
        CrawlMapVisualizer(map: crawlMap)
      } else {
        ContentUnavailableView("No Crawl Data", 
          systemImage: "globe.desk")
      }
    }
  }
  
  // MARK: - Private Methods
  
  /// Starts the crawl operation with the current configuration
  private func startCrawl() async {
    do {
      isCrawling = true
      crawlError = nil
      
      let result = try await agniKit.crawl(
        url: startURL,
        excludePaths: crawlRules.excludePaths,
        includePaths: crawlRules.includePaths,
        maxDepth: crawlRules.maxDepth,
        ignoreSitemap: crawlRules.ignoreSitemap,
        limit: maxPages,
        allowBackwardLinks: crawlRules.allowBackwardLinks,
        allowExternalLinks: crawlRules.allowExternalLinks
      )
      
      // Convert API response to CrawlMap
    //  crawlMap = CrawlMap(from: result)
      
    } catch {
      crawlError = error
    }
    
    isCrawling = false
  }
  
  /// Cancels the current crawl operation if one is in progress
  private func cancelCrawl() async {
    guard let jobId = crawlMap?.jobId else { return }
    
    do {
      _ = try await agniKit.cancelCrawl(id: jobId)
      isCrawling = false
    } catch {
      crawlError = error
    }
  }
}

// MARK: - Preview Provider

#Preview {
  CrawlerView()
}
