import SwiftUI

/// A view that renders basic Markdown content using SwiftUI Text.
///
/// `MarkdownView` provides a lightweight way to display formatted Markdown text
/// using SwiftUI's built-in AttributedString markdown parsing.
///
/// ## Usage
/// ```swift
/// MarkdownView("# Hello\nThis is **bold** and *italic* text")
/// ```
struct MarkdownView: View {
  /// The formatted content to be displayed
  private let content: AttributedString
  
  /// Creates a new MarkdownView with the specified content.
  ///
  /// - Parameter content: A string containing Markdown-formatted text
  init(_ content: String) {
    do {
      self.content = try AttributedString(markdown: content)
    } catch {
      print("Error parsing markdown: \(error)")
      self.content = AttributedString(content)
    }
  }
  
  var body: some View {
    Text(content)
      .textSelection(.enabled)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
  }
} 