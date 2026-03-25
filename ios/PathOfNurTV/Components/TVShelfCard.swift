import SwiftUI

struct TVShelfCard: View {
  let item: TVShelfItem

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
          .fill(
            LinearGradient(
              colors: [TVTheme.surfaceElevated, TVTheme.surface],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 420, height: 220)
          .overlay(
            RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
              .stroke(TVTheme.surfaceStroke, lineWidth: 1)
          )
          .shadow(color: TVTheme.surfaceShadow, radius: 20, x: 0, y: 12)

        Image(systemName: item.systemImage)
          .font(.system(size: 46, weight: .semibold))
          .foregroundColor(TVTheme.focus)
          .padding(24)
      }

      Text(item.title)
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.textPrimary)
        .lineLimit(2)
        .tvReadableTitle()

      Text(item.subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(3)
        .tvReadableBody()
    }
    .frame(width: 420, alignment: .leading)
    .tvFocusableCard()
    .tvCombinedAccessibility(label: item.title, hint: item.subtitle)
  }
}
