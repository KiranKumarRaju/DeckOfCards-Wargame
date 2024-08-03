import Foundation
import os

private struct BuildConfigurationTypes: Codable {
  let release: BuildConfiguration
  let debug: BuildConfiguration
}

struct BuildConfiguration: Codable {
  let serverUrl: String
}

enum BuildConfigurations {
  static func fetchConfiguration() throws -> BuildConfiguration {
  
    guard let sdkBundle = Bundle.init(identifier: "com.mycompany.sdk.deckofcards.ios"),
  
    let configurationsFilePath = sdkBundle.url(forResource: "BuildConfigurations", withExtension: "plist"),
    let configuration = try? Data(contentsOf: configurationsFilePath) else {
      throw ConfigurationsError.retrieval(message: "Failed to load configuration information")
    }
    
    let configurationTypes = try PropertyListDecoder().decode(BuildConfigurationTypes.self, from: configuration)
    
#if DEBUG
  let buildVariant = "Debug"
#else
  let buildVariant = "Release"
#endif
  
  if buildVariant.caseInsensitiveCompare("Debug") == .orderedSame {
    return configurationTypes.debug
  } else {
    return configurationTypes.release
  }
  }
}

enum ConfigurationsError: LocalizedError {
  case retrieval(message: String)
}
