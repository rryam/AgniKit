//
//  ContentView.swift
//  Agni
//
//  Created by Rudrank Riyam on 11/5/24.
//

import SwiftUI

import SwiftUI
import AgniKit

struct ContentView: View {
  @StateObject private var viewModel = ScrapingViewModel()
  
  var body: some View {
    NavigationSplitView {
      Sidebar()
    } detail: {
      TabView {
        QuickScrapeView()
          .tabItem { 
            Label("Quick Scrape", systemImage: "bolt")
          }
        
        BatchScrapeView()
          .tabItem {
            Label("Batch Scrape", systemImage: "list.bullet")
          }
        
        CrawlerView()
          .tabItem {
            Label("Crawler", systemImage: "network")
          }
        
        SettingsView()
          .tabItem {
            Label("Settings", systemImage: "gear")
          }
      }
    }
  }
}