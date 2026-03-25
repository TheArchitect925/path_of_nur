import SwiftUI

struct TVEmptyStateCard: View {
  let title: String
  let subtitle: String
  let supportingLine: String

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(title)
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()

      Text(supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .tvReadableBody()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(title)
    .accessibilityHint(subtitle)
    .accessibilityValue(supportingLine)
  }
}
