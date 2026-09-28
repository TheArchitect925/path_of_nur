import SwiftUI

struct WatchQuickActionButton: View {
  @Environment(\.watchPalette) private var palette
  let title: String
  let systemImage: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 6) {
        Image(systemName: systemImage)
          .font(.system(size: 16, weight: .semibold))
          .foregroundStyle(palette.accent)
        Text(title)
          .font(WatchType.caption)
          .foregroundStyle(palette.onSurfaceSubtle)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
      .frame(maxWidth: .infinity, minHeight: 58)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(palette.cardFillSoft)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .strokeBorder(palette.border.opacity(0.4), lineWidth: 1)
      )
    }
    .buttonStyle(.plain)
  }
}
