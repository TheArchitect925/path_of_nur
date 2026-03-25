import Foundation

func tvLocalized(_ key: String) -> String {
  NSLocalizedString(key, comment: "")
}

func tvLocalized(_ key: String, _ arguments: CVarArg...) -> String {
  String(format: tvLocalized(key), locale: Locale.current, arguments: arguments)
}
