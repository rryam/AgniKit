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