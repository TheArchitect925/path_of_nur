import SwiftUI

struct TVDhikrModeCardView: View {
  let item: TVDhikrModeCard
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(item.eyebrow.uppercased())
        .font(TVTypography.badge)
        .foregroundColor(TVTheme.focus)

      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 8) {
          Text(item.title)
            .font(TVTypography.featureTitle)
            .foregroundColor(TVTheme.textPrimary)

          Text(item.subtitle)
            .font(TVTypography.featureSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(3)
        }

        Spacer(minLength: 0)

        Image(systemName: item.systemImage)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(3)

      HStack(spacing: 10) {
        ForEach(item.focusPhrases, id: \.self) { phrase in
          Text(phrase)
            .font(TVTypography.caption)
            .foregroundColor(TVTheme.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(TVTheme.surfaceSoft.opacity(0.8), in: Capsule())
        }
      }

      if isSelected {
        Text(tvLocalized("Selected mode"))
          .font(TVTypography.caption)
          .foregroundColor(TVTheme.focus)
      }
    }
    .frame(width: 420, height: 260, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected)
    .tvFocusableCard()
  }
}
