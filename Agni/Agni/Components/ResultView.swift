import SwiftUI

struct ResultView: View {
  let content: String
  @State private var selectedFormat: String = "markdown"
  
  var body: some View {
    VStack {
      Picker("Format", selection: $selectedFormat) {
        Text("Markdown").tag("markdown")
        Text("HTML").tag("html")
        Text("Raw HTML").tag("rawHtml")
      }
      .pickerStyle(.segmented)
      
      ScrollView {
        if selectedFormat == "markdown" {
         MarkdownView(content)
        } else {
          TextEditor(text: .constant(content))
            .font(.system(.body, design: .monospaced))
        }
      }
    }
  }
} 
