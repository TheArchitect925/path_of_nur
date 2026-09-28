import SwiftUI

enum TVSurfaceStyles {
  /// The phone's glass-card grammar: a near-opaque surface fill with an
  /// edge-light border gradient (bright toward the light, settling into the
  /// palette border), gold-emphasized when the card asks for attention.
  @ViewBuilder
  static func cardBackground(
    elevated: Bool = false,
    emphasized: Bool = false
  ) -> some View {
    let shape = RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
    shape
      .fill(elevated ? TVTheme.surfaceElevated : TVTheme.surface)
      .overlay(
        Group {
          if emphasized {
            shape.strokeBorder(
              TVTheme.current.accent.opacity(0.45),
              lineWidth: 1.6
            )
          } else {
            shape.strokeBorder(TVTheme.current.cardBorderGradient, lineWidth: 1)
          }
        }
      )
      .shadow(
        color: TVTheme.surfaceShadow,
        radius: elevated ? 24 : 18,
        x: 0,
        y: elevated ? 14 : 10
      )
  }
}

extension View {
  func tvSurfaceCard(
    elevated: Bool = false,
    emphasized: Bool = false
  ) -> some View {
    background(TVSurfaceStyles.cardBackground(elevated: elevated, emphasized: emphasized))
  }
}
