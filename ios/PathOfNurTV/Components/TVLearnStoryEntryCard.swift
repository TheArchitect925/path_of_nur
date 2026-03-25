import SwiftUI

struct TVLearnStoryEntryCard: View {
  let entry: TVLearnStoryEntry
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
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
            .lineLimit(4)
        }

        Spacer(minLength: 0)

        Image(systemName: entry.systemImage)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      Spacer(minLength: 0)

      Text(entry.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(3)
    }
    .frame(width: 350, height: 250, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected)
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(isSelected ? TVTheme.accentSoft : .clear, lineWidth: isSelected ? 2 : 0)
    )
    .tvFocusableCard()
  }
}
