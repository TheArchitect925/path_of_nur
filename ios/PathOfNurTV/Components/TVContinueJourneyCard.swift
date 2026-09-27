import SwiftUI

struct TVContinueJourneyCard: View {
  let item: TVContinueJourneyItem

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      if !item.eyebrow.isEmpty {
        Text(item.eyebrow.uppercased())
          .font(TVTypography.badge)
          .foregroundColor(TVTheme.focus)
      }

      Image(systemName: item.systemImage)
        .font(.system(size: 28, weight: .semibold))
        .foregroundColor(TVTheme.accentStrong)

      VStack(alignment: .leading, spacing: 8) {
        Text(item.title)
          .font(TVTypography.featureTitle)
          .foregroundColor(TVTheme.textPrimary)

        if !item.subtitle.isEmpty {
          Text(item.subtitle)
            .font(TVTypography.featureSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(3)
        }

        if !item.supportingLine.isEmpty {
          Text(item.supportingLine)
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.textMuted)
            .lineLimit(2)
        }
      }
    }
    .frame(width: 360, height: 250, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: true)
    .tvFocusableCard()
  }
}
