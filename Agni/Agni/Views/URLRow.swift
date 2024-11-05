import SwiftUI

/// A view that displays a single URL with options to edit or remove it
struct URLRow: View {
  let url: String
  @State private var isEditing = false
  
  var body: some View {
    HStack {
      Text(url)
        .lineLimit(1)
        .truncationMode(.middle)
      
      Spacer()
      
      Button(action: { isEditing = true }) {
        Image(systemName: "pencil")
      }
      
      Button(action: { /* Add delete action */ }) {
        Image(systemName: "trash")
          .foregroundColor(.red)
      }
    }
    .sheet(isPresented: $isEditing) {
      URLEditView(url: url)
    }
  }
} 
