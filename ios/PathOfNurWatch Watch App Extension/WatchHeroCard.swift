import SwiftUI

struct WatchHeroCard<Content: View>: View {
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
                ? [WatchTheme.accent.opacity(0.18), WatchTheme.card]
                : [WatchTheme.card, WatchTheme.card],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
    )
    .overlay(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .stroke(glow ? WatchTheme.accent.opacity(0.35) : WatchTheme.cardBorder, lineWidth: 1)
    )
    .shadow(color: glow ? WatchTheme.accent.opacity(0.18) : .clear, radius: 10)
  }
}
