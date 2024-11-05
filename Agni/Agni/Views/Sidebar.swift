import SwiftUI

/// A view that provides the sidebar navigation for the Agni app.
///
/// The `Sidebar` view displays a list of navigation options that allows users to access
/// different sections of the app. It's designed to work within a `NavigationSplitView`
/// and provides quick access to key features.
struct Sidebar: View {
  /// The currently selected navigation item.
  @State private var selection: NavigationItem? = .quickScrape
  
  var body: some View {
    List(selection: $selection) {
      Section("Scraping") {
        NavigationLink(value: NavigationItem.quickScrape) {
          Label("Quick Scrape", systemImage: "bolt")
        }
        
        NavigationLink(value: NavigationItem.batchScrape) {
          Label("Batch Scrape", systemImage: "list.bullet")
        }
      }
      
      Section("Tools") {
        NavigationLink(value: NavigationItem.crawler) {
          Label("Crawler", systemImage: "network")
        }
        
        NavigationLink(value: NavigationItem.settings) {
          Label("Settings", systemImage: "gear")
        }
      }
    }
    .navigationTitle("Agni")
  }
}

/// Represents the different navigation destinations available in the sidebar.
enum NavigationItem: Hashable {
  /// Quick scraping of individual URLs
  case quickScrape
  /// Batch scraping of multiple URLs
  case batchScrape
  /// Web crawler configuration and control
  case crawler
  /// App settings and preferences
  case settings
}

#Preview {
  NavigationSplitView {
    Sidebar()
  } detail: {
    Text("Select an option")
  }
} 