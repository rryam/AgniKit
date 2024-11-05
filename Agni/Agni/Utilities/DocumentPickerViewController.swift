import AppKit

/// A wrapper for NSOpenPanel to use with SwiftUI
class DocumentPickerViewController: NSOpenPanel {
  private let onPick: (URL) -> Void
  
  init(supportedTypes: [String], onPick: @escaping (URL) -> Void) {
    self.onPick = onPick
    super.init()
    self.allowedFileTypes = supportedTypes
    self.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Presents the document picker to the user
  ///
  /// This method displays the document picker interface to allow the user to select a file.
  ///
  /// - Parameter parent: The parent view controller from which to present the document picker.
  func present(from parent: NSViewController) {
    self.beginSheetModal(for: parent.view.window!) { response in
      if response == .OK, let url = self.url {
        self.onPick(url)
      }
    }
  }
}

extension DocumentPickerViewController: NSOpenSavePanelDelegate {
  func panel(_ sender: NSOpenPanel, didChangeToDirectoryURL url: URL?) {
    // Handle directory change if needed
  }
}
