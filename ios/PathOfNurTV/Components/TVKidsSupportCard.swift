import SwiftUI

struct TVKidsSupportCardView: View {
  let item: TVKidsSupportCard

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
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

      Spacer(minLength: 0)

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(3)
    }
    .frame(width: 350, height: 220, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: false)
    .tvFocusableCard()
  }
}
