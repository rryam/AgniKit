import SwiftUI
import AgniKit

/// A view that manages application-wide settings and preferences
/// 
/// The `SettingsView` provides a form-based interface for users to configure:
/// - API credentials
/// - Default location and language preferences
/// - Export options and formats
/// - Advanced configuration options
struct SettingsView: View {
  // MARK: - Properties
  
  @AppStorage("apiKey") private var apiKey = ""
  @AppStorage("defaultLocation") private var defaultLocation: CountryCode = .unitedStates
  @AppStorage("defaultLanguages") private var defaultLanguages: String = "en-US"

  // MARK: - Body
  
  var body: some View {
    Form {
      Section("API Configuration") {
        SecureField("API Key", text: $apiKey)
          .textContentType(.password)
          .help("Enter your API key to enable services")
      }
      
      Section("Default Location") {
        Picker("Country", selection: $defaultLocation) {
          ForEach(CountryCode.allCases, id: \.self) { code in
            Text(code.rawValue).tag(code)
          }
        }
        .help("Select your primary operating country")
        
      //  LanguageSelector(selectedLanguages: $defaultLanguages)
      }
      
      Section("Export Options") {
       // ExportOptionsView()
      }
      
      Section("Advanced") {
        Button("Reset All Settings") {
          resetSettings()
        }
        .foregroundColor(.red)
      }
    }
    .navigationTitle("Settings")
  }
  
  // MARK: - Methods
  
  /// Resets all settings to their default values
  private func resetSettings() {
    apiKey = ""
    defaultLocation = .unitedStates
    defaultLanguages = "en-US"
  }
}

// MARK: - Preview Provider

#Preview {
  SettingsView()
} 
