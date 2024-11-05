import SwiftUI
import AgniKit

/// A view that visualizes the crawl map as an interactive graph.
///
/// This view displays the relationships between crawled pages using a
/// force-directed graph layout.
struct CrawlMapVisualizer: View {
  /// The crawl map to visualize
  let map: CrawlMap
  
  /// Selected page for showing details
  @State private var selectedPage: CrawlPage?

  /// View state for graph layout
  @State private var nodes: [NodeView] = []
  @State private var edges: [EdgeView] = []
  
  var body: some View {
    ZStack {
      // Graph View
      GraphView(nodes: nodes, edges: edges) { page in
        selectedPage = page as? CrawlPage
      }
      
      // Details Panel
      if let page = selectedPage {
        VStack(alignment: .leading) {
          Text("Page Details")
            .font(.headline)
          
          Text("URL: \(page.url.absoluteString)")
          Text("Title: \(page.title)")
          Text("Depth: \(page.depth)")
          Text("Status: \(page.status)")
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding()
      }
    }
    .onAppear {
      setupGraph()
    }
  }
  
  /// Sets up the graph visualization
  private func setupGraph() {
    // Create nodes for each page
    nodes = map.pages.map { page in
      NodeView(
        id: page.id,
        data: page,
        position: randomPosition()
      )
    }
    
    // Create edges for each link
    edges = map.links.map { link in
      EdgeView(
        id: link.id,
        source: link.sourceId,
        target: link.targetId,
        data: link
      )
    }
  }
  
  /// Generates a random position for initial node placement
  private func randomPosition() -> CGPoint {
    CGPoint(
      x: CGFloat.random(in: 100...500),
      y: CGFloat.random(in: 100...500)
    )
  }
}

/// A view that renders the force-directed graph
private struct GraphView: View {
  let nodes: [NodeView]
  let edges: [EdgeView]
  let onNodeSelected: (Any) -> Void
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Draw edges
        ForEach(edges) { edge in
          if let source = findNode(id: edge.source),
             let target = findNode(id: edge.target) {
            Path { path in
              path.move(to: source.position)
              path.addLine(to: target.position)
            }
            .stroke(.gray, lineWidth: 1)
          }
        }
        
        // Draw nodes
        ForEach(nodes) { node in
          Circle()
            .fill(.blue)
            .frame(width: 10, height: 10)
            .position(node.position)
            .onTapGesture {
              onNodeSelected(node.data)
            }
        }
      }
    }
  }
  
  private func findNode(id: String) -> NodeView? {
    nodes.first { $0.id == id }
  }
}

/// Represents a node in the graph visualization
private struct NodeView: Identifiable {
  let id: String
  let data: Any
  var position: CGPoint
}

/// Represents an edge in the graph visualization
private struct EdgeView: Identifiable {
  let id: String
  let source: String
  let target: String
  let data: Any
}

#Preview {
  // Create sample data for preview
  let sampleMap = CrawlMap(from: .init(
    jobId: "preview",
    startUrl: URL(string: "https://example.com")!,
    pages: [],
    links: []
  ))
  
  return CrawlMapVisualizer(map: sampleMap)
} 
