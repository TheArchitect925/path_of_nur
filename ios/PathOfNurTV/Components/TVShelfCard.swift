import SwiftUI

struct TVShelfCard: View {
  let item: TVShelfItem

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
          .fill(TVTheme.surface)
          .frame(width: 420, height: 220)

        Image(systemName: item.systemImage)
          .font(.system(size: 46, weight: .semibold))
          .foregroundStyle(TVTheme.focus)
          .padding(24)
      }

      Text(item.title)
        .font(.system(size: 28, weight: .bold, design: .rounded))
        .foregroundStyle(TVTheme.textPrimary)
        .lineLimit(2)

      Text(item.subtitle)
        .font(.system(size: 18, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
        .lineLimit(3)
    }
    .frame(width: 420, alignment: .leading)
    .tvFocusableCard()
  }
}
