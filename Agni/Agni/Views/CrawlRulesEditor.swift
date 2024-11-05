import SwiftUI

/// A view for editing crawl rules and parameters.
///
/// This view provides a user interface for modifying various crawling parameters
/// such as included/excluded paths, depth limits, and link following behavior.
struct CrawlRulesEditor: View {
  /// Binding to the rules being edited
  @Binding var rules: CrawlRules
  
  /// State for managing the new path input
  @State private var newPath = ""
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Depth Control
      Stepper("Max Depth: \(rules.maxDepth)", value: $rules.maxDepth, in: 1...10)
      
      // Toggle Controls
      Toggle("Ignore Sitemap", isOn: $rules.ignoreSitemap)
      Toggle("Allow Backward Links", isOn: $rules.allowBackwardLinks)
      Toggle("Allow External Links", isOn: $rules.allowExternalLinks)
      
      // Path Management
      GroupBox("Include Paths") {
        PathList(
          paths: $rules.includePaths,
          newPath: $newPath,
          placeholder: "Add path to include"
        )
      }
      
      GroupBox("Exclude Paths") {
        PathList(
          paths: $rules.excludePaths,
          newPath: $newPath,
          placeholder: "Add path to exclude"
        )
      }
    }
  }
}

/// A reusable view for managing a list of paths
private struct PathList: View {
  @Binding var paths: [String]
  @Binding var newPath: String
  let placeholder: String
  
  var body: some View {
    VStack {
      List {
        ForEach(paths, id: \.self) { path in
          Text(path)
        }
        .onDelete { paths.remove(atOffsets: $0) }
      }
      .frame(height: 100)
      
      HStack {
        TextField(placeholder, text: $newPath)
          .textFieldStyle(.roundedBorder)
        
        Button("Add") {
          if !newPath.isEmpty {
            paths.append(newPath)
            newPath = ""
          }
        }
      }
    }
  }
}

#Preview {
  CrawlRulesEditor(rules: .constant(CrawlRules()))
    .padding()
} 