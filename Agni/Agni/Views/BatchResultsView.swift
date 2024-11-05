import SwiftUI
//
///// A view that displays the results of a batch scrape operation
//struct BatchResultsView: View {
//  let results: [BatchScrapeResult]
//  
//  var body: some View {
//    List(results, id: \.metadata.sourceURL) { result in
//      VStack(alignment: .leading) {
//        Text(result.metadata.title)
//          .font(.headline)
//        
//        Text(result.metadata.sourceURL)
//          .font(.caption)
//          .foregroundColor(.secondary)
//        
//        if let markdown = result.markdown {
//          Text(markdown)
//            .lineLimit(3)
//            .padding(.top, 4)
//        }
//      }
//      .padding(.vertical, 4)
//    }
//  }
//} 
