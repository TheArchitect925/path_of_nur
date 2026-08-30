import SwiftUI

/// Glass card mirroring the phone's PremiumCard: theme surface fill, an
/// edge-light border, and a gold glow reserved for completed moments.
struct WatchHeroCard<Content: View>: View {
  @Environment(\.watchPalette) private var palette
  let glow: Bool
  @ViewBuilder let content: Content

  init(glow: Bool = false, @ViewBuilder content: () -> Content) {
    self.glow = glow
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      content
    }
    .padding(12)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(
          LinearGradient(
            colors: glow
                ? [palette.accent.opacity(0.20), palette.cardFill]
                : [palette.cardFill, palette.cardFillSoft],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
    )
    .overlay(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .strokeBorder(
          glow
              ? AnyShapeStyle(palette.accent.opacity(0.45))
              : AnyShapeStyle(palette.cardBorderGradient),
          lineWidth: 1
        )
    )
    .shadow(color: glow ? palette.accent.opacity(0.20) : .clear, radius: 10)
  }
}
