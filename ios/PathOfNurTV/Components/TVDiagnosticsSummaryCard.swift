import SwiftUI

struct TVDiagnosticsSummaryCard: View {
  let summary: TVDiagnosticsSummary

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(summary.eyebrow.uppercased())
        .font(TVTypography.badge)
        .foregroundColor(TVTheme.focus)

      Text(summary.title)
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(summary.subtitle)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()

      if !summary.chips.isEmpty {
        HStack(spacing: 10) {
          ForEach(summary.chips, id: \.self) { chip in
            Text(chip)
              .font(TVTypography.badge)
              .foregroundColor(TVTheme.textPrimary)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(
                Capsule(style: .continuous)
                  .fill(TVTheme.surfaceSoft)
              )
          }
        }
      }

      Text(summary.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .tvReadableBody()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: false)
    .tvCombinedAccessibility(
      label: summary.title,
      hint: summary.subtitle,
      value: summary.chips.joined(separator: ", ")
    )
  }
}
