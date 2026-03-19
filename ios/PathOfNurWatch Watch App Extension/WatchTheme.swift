import SwiftUI

enum WatchTheme {
  static let background = Color(red: 0.04, green: 0.05, blue: 0.08)
  static let backgroundGlow = Color(red: 0.42, green: 0.31, blue: 0.14)
  static let card = Color.white.opacity(0.08)
  static let cardHighlight = accent.opacity(0.14)
  static let cardBorder = Color.white.opacity(0.08)
  static let accent = Color(red: 0.84, green: 0.74, blue: 0.50)
  static let accentSoft = Color(red: 0.96, green: 0.88, blue: 0.72)
  static let success = Color(red: 0.53, green: 0.82, blue: 0.62)
  static let warning = Color(red: 0.91, green: 0.56, blue: 0.35)
  static let secondaryText = Color.white.opacity(0.72)

  static var backgroundGradient: LinearGradient {
    LinearGradient(
      colors: [backgroundGlow.opacity(0.22), background],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}
