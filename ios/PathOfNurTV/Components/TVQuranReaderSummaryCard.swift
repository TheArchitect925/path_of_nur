import SwiftUI

struct TVQuranReaderSummaryCard: View {
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(eyebrow.uppercased())
        .font(TVTypography.badge)
        .foregroundColor(TVTheme.focus)

      Text(title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)

      Text(subtitle)
        .font(TVTypography.summaryLine)
        .foregroundColor(TVTheme.accentStrong)

      Text(supportingLine)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(3)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: true)
    .tvFocusableCard()
  }
}
