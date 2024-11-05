import SwiftUI 

struct QuickScrapeView: View {
  @State private var url = ""
  @State private var formats = ["markdown"]
  @State private var onlyMainContent = true
  @State private var includeTags: String = ""
  @State private var excludeTags: String = ""
  @State private var result: String = ""
  @State private var waitTime: Double = 0
  @State private var timeout: Double = 30
  
  var body: some View {
    Form {
      Section("Input") {
        TextField("URL", text: $url)
        
        Toggle("Only Main Content", isOn: $onlyMainContent)
        
        LabeledContent("Formats") {
          FormatsPicker(selection: $formats)
        }
        
        TextField("Include Tags (comma-separated)", text: $includeTags)
        TextField("Exclude Tags (comma-separated)", text: $excludeTags)
      }
      
      Section("Advanced Options") {
        HeadersEditor()
        WaitTimeSelector()
        TimeoutSelector()
      }
      
      Section("Actions") {
        Button("Scrape") {
          Task {
            await performScrape()
          }
        }
      }
      
      Section("Result") {
        ResultView(content: result)
          .contextMenu {
            Button("Copy") {
              NSPasteboard.general.setString(result, forType: .string)
            }
            Button("Save As...") {
              saveToFile()
            }
          }
      }
    }
    .padding()
  }
}

struct HeadersEditor: View {
  @State private var headers: [Header] = []
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Headers")
        .font(.headline)
      
      ForEach($headers) { $header in
        HStack {
          TextField("Key", text: $header.key)
          TextField("Value", text: $header.value)
          
          Button(action: {
            headers.removeAll { $0.id == header.id }
          }) {
            Image(systemName: "minus.circle.fill")
              .foregroundColor(.red)
          }
        }
      }
      
      Button(action: {
        headers.append(Header())
      }) {
        Label("Add Header", systemName: "plus")
      }
    }
    .padding(.vertical, 4)
  }
}

struct WaitTimeSelector: View {
  @State private var waitTime: Double = 0
  
  var body: some View {
    HStack {
      Text("Wait Time")
      Slider(value: $waitTime, in: 0...10, step: 0.5)
      Text("\(waitTime, specifier: "%.1f")s")
    }
  }
}

struct TimeoutSelector: View {
  @State private var timeout: Double = 30
  
  var body: some View {
    HStack {
      Text("Timeout")
      Slider(value: $timeout, in: 5...60, step: 5)
      Text("\(timeout, specifier: "%.0f")s")
    }
  }
}

struct Header: Identifiable {
  let id = UUID()
  var key: String = ""
  var value: String = ""
}