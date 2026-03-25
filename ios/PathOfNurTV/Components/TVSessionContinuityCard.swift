import SwiftUI

struct TVSessionContinuityCardView: View {
  let item: TVSessionContinuityCard
  let isSelected: Bool
  let isActive: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack {
        Label(item.eyebrow, systemImage: item.systemImage)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.focus)

        Spacer(minLength: 12)

        if isActive {
          Text(tvLocalized("Now"))
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.prayerCurrentText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
              Capsule(style: .continuous)
                .fill(TVTheme.prayerCurrent)
            )
        }
      }

      Text(item.title)
        .font(TVTypography.sectionTitle)
        .foregroundColor(isSelected ? TVTheme.accentStrong : TVTheme.textPrimary)
        .tvReadableTitle()

      Text(item.subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .tvReadableBody()

      Text(item.detailLine)
        .font(TVTypography.summaryLine)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableBody()

      HStack(spacing: 10) {
        ForEach(item.chips, id: \.self) { chip in
          Text(chip)
            .font(TVTypography.detail)
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
    .frame(width: 380, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected || isActive)
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: item.title,
      hint: item.subtitle,
      value: isActive ? tvLocalized("Active") : nil
    )
  }
}
