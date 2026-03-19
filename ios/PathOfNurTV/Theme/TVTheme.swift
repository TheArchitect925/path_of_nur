import SwiftUI

enum TVTheme {
  static let backgroundTop = Color(red: 0.93, green: 0.89, blue: 0.84)
  static let backgroundBottom = Color(red: 0.85, green: 0.82, blue: 0.77)
  static let surface = Color.white.opacity(0.54)
  static let surfaceSoft = Color.white.opacity(0.36)
  static let surfaceElevated = Color(red: 0.98, green: 0.95, blue: 0.89)
  static let accentSoft = Color(red: 0.95, green: 0.84, blue: 0.54)
  static let accentStrong = Color(red: 0.72, green: 0.57, blue: 0.34)
  static let focus = Color(red: 0.72, green: 0.57, blue: 0.34)
  static let textPrimary = Color(red: 0.23, green: 0.18, blue: 0.15)
  static let textSecondary = Color(red: 0.40, green: 0.33, blue: 0.27)
  static let textMuted = Color(red: 0.48, green: 0.41, blue: 0.35)
  static let prayerCurrent = Color(red: 0.82, green: 0.91, blue: 0.83)
  static let prayerCurrentText = Color(red: 0.20, green: 0.35, blue: 0.22)
  static let prayerNext = Color(red: 0.95, green: 0.88, blue: 0.72)
  static let prayerNextText = Color(red: 0.42, green: 0.30, blue: 0.16)
  static let cautionText = Color(red: 0.53, green: 0.33, blue: 0.18)

  static let outerPadding: CGFloat = 56
  static let sectionSpacing: CGFloat = 28
  static let railSpacing: CGFloat = 18
  static let cardRadius: CGFloat = 30
  static let focusScale: CGFloat = 1.05
}
