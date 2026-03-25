import SwiftUI

struct TVLearnHubItemCard: View {
  let item: TVLearnHubItem
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(item.eyebrow.uppercased())
        .font(TVTypography.badge)
        .foregroundColor(TVTheme.focus)
        .tvReadableBody()

      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 8) {
          Text(item.title)
            .font(TVTypography.featureTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          Text(item.subtitle)
            .font(TVTypography.featureSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(3)
            .tvReadableBody()
        }

        Spacer(minLength: 0)

        Image(systemName: item.systemImage)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(2)
        .tvReadableBody()
    }
    .frame(width: 350, height: 220, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected)
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(isSelected ? TVTheme.accentSoft : .clear, lineWidth: isSelected ? 2 : 0)
    )
    .tvFocusableCard()
    .tvCombinedAccessibility(label: item.title, hint: item.subtitle)
  }
}
