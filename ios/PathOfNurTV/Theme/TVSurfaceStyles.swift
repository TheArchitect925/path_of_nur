import SwiftUI

enum TVSurfaceStyles {
  @ViewBuilder
  static func cardBackground(
    elevated: Bool = false,
    emphasized: Bool = false
  ) -> some View {
    RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
      .fill(elevated ? TVTheme.surfaceElevated : TVTheme.surface)
      .overlay(
        RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
          .stroke(
            emphasized ? TVTheme.accentSoft.opacity(0.45) : TVTheme.surfaceStroke,
            lineWidth: emphasized ? 1.6 : 1
          )
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

