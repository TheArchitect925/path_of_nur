import SwiftUI

struct WatchStatChip: View {
  @Environment(\.watchPalette) private var palette
  let title: String
  let value: String

  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(title.uppercased())
        .font(.system(size: 9, weight: .semibold))
        .tracking(0.8)
        .foregroundStyle(palette.onSurfaceMuted)
      Text(value)
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(palette.onSurface)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .fill(palette.cardFillSoft)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .strokeBorder(palette.border.opacity(0.4), lineWidth: 1)
    )
  }
}
