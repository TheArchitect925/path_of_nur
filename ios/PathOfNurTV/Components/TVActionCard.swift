import SwiftUI

struct TVActionCard: View {
  let title: String
  let subtitle: String
  let systemImage: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Image(systemName: systemImage)
        .font(.system(size: 30, weight: .semibold))
        .foregroundColor(TVTheme.accentStrong)

      Text(title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(3)
        .tvReadableBody()
    }
    .frame(width: 340, height: 214, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard()
    .tvFocusableCard()
    .tvCombinedAccessibility(label: title, hint: subtitle)
  }
}
