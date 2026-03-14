import SwiftUI

enum TVTheme {
    static let backgroundTop = Color(red: 0.06, green: 0.10, blue: 0.16)
    static let backgroundBottom = Color(red: 0.02, green: 0.03, blue: 0.06)
    static let surface = Color.white.opacity(0.09)
    static let surfaceSoft = Color.white.opacity(0.05)
    static let focus = Color(red: 0.87, green: 0.78, blue: 0.56)
    static let accent = Color(red: 0.56, green: 0.72, blue: 0.93)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.78)
    static let textTertiary = Color.white.opacity(0.58)

    static let outerPadding: CGFloat = 54
    static let sectionSpacing: CGFloat = 28
    static let railSpacing: CGFloat = 18
    static let cardRadius: CGFloat = 28
    static let focusScale: CGFloat = 1.05
}
