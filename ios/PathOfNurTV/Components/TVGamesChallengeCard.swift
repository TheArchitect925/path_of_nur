import SwiftUI

struct TVGamesChallengeCardView: View {
  let item: TVGamesChallengeCard
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      Text(item.eyebrow)
        .font(TVTypography.heroEyebrow)
        .foregroundColor(TVTheme.focus)

      VStack(alignment: .leading, spacing: 10) {
        Text(item.title)
          .font(TVTypography.sectionTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(item.subtitle)
          .font(TVTypography.sectionSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .lineLimit(3)
      }

      Spacer(minLength: 0)

      Label(item.supportingLine, systemImage: item.systemImage)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .labelStyle(.titleAndIcon)
        .lineLimit(3)
    }
    .frame(width: 360, alignment: .leading)
    .frame(minHeight: 250, alignment: .topLeading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: isSelected, emphasized: isSelected)
  }
}
