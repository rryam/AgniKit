//
//  BatchScrapeView.swift
//  Agni
//
//  Created by Rudrank Riyam on 11/5/24.
//

import SwiftUI

struct BatchScrapeView: View {
  @State private var urls: [String] = []
  @State private var results: [BatchScrapeResult] = []
  @State private var isProcessing = false
  
  var body: some View {
    VStack {
      List {
        ForEach(urls, id: \.self) { url in
          URLRow(url: url)
        }
      }
      
      HStack {
        Button("Add URLs") {
          showURLInput()
        }
        
        Button("Import from CSV") {
          importFromCSV()
        }
        
        Button("Start Batch") {
          Task {
            await startBatchScrape()
          }
        }
        .disabled(urls.isEmpty || isProcessing)
      }
      
      if isProcessing {
        ProgressView()
          .progressViewStyle(.circular)
      }
      
      BatchResultsView(results: results)
    }
  }
}

extension BatchScrapeView {
  /// Shows a dialog to input new URLs
  private func showURLInput() {
    // Create an alert or sheet to input URLs
    let alert = UIAlertController(
      title: "Add URLs",
      message: "Enter URLs (one per line)",
      preferredStyle: .alert
    )
    
    alert.addTextField { textField in
      textField.placeholder = "https://example.com"
      textField.keyboardType = .URL
    }
    
    alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
      if let input = alert.textFields?.first?.text {
        let newURLs = input.components(separatedBy: .newlines)
          .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
          .filter { !$0.isEmpty }
        urls.append(contentsOf: newURLs)
      }
    })
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    // Present the alert
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let viewController = windowScene.windows.first?.rootViewController {
      viewController.present(alert, animated: true)
    }
  }
  
  /// Imports URLs from a CSV file
  private func importFromCSV() {
    let picker = DocumentPickerViewController(
      supportedTypes: ["public.comma-separated-values-text"],
      onPick: { url in
        do {
          let content = try String(contentsOf: url)
          let newURLs = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
          urls.append(contentsOf: newURLs)
        } catch {
          print("Error reading CSV: \(error)")
        }
      }
    )
    
    // Present the picker
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let viewController = windowScene.windows.first?.rootViewController {
      viewController.present(picker, animated: true)
    }
  }
  
  /// Starts the batch scrape operation
  private func startBatchScrape() async {
    guard !urls.isEmpty else { return }
    
    isProcessing = true
    defer { isProcessing = false }
    
    do {
      let agniKit = AgniKit(apiKey: "YOUR_API_KEY") // Replace with actual API key
      let response = try await agniKit.batchScrape(urls: urls)
      results = response.data
    } catch {
      print("Batch scrape error: \(error)")
    }
  }
}