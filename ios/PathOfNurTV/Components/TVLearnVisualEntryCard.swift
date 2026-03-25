import SwiftUI

struct TVLearnVisualEntryCard: View {
  let entry: TVLearnVisualEntry
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 8) {
          Text(entry.eyebrow.uppercased())
            .font(TVTypography.badge)
            .foregroundColor(TVTheme.focus)

          Text(entry.title)
            .font(TVTypography.featureTitle)
            .foregroundColor(TVTheme.textPrimary)

          Text(entry.subtitle)
            .font(TVTypography.featureSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(3)
        }

        Spacer(minLength: 0)

        Image(systemName: entry.systemImage)
          .font(.system(size: 28, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      Spacer(minLength: 0)

      Text(entry.accentLabel)
        .font(TVTypography.chip)
        .foregroundColor(TVTheme.prayerNextText)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
          Capsule(style: .continuous)
            .fill(TVTheme.prayerNext.opacity(0.85))
        )

      Text(entry.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(3)
    }
    .frame(width: 390, height: 270, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .background(
      LinearGradient(
        colors: [
          TVTheme.surfaceElevated,
          TVTheme.backgroundMeshTop.opacity(0.92),
          TVTheme.backgroundMeshBottom.opacity(0.72),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .clipShape(RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(isSelected ? TVTheme.accentSoft : TVTheme.surfaceStroke, lineWidth: isSelected ? 2 : 1)
    )
    .shadow(color: TVTheme.surfaceShadow, radius: 20, x: 0, y: 12)
    .tvFocusableCard()
  }
}
