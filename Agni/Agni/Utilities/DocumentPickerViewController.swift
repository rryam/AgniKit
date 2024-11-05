/// A wrapper for UIDocumentPickerViewController to use with SwiftUI
class DocumentPickerViewController: UIDocumentPickerViewController {
  private let onPick: (URL) -> Void
  
  init(supportedTypes: [String], onPick: @escaping (URL) -> Void) {
    self.onPick = onPick
    super.init(forOpeningContentTypes: supportedTypes.map { UTType(tag: $0, tagClass: .filenameExtension, conformingTo: nil)! })
    self.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DocumentPickerViewController: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let url = urls.first else { return }
    onPick(url)
  }
} 