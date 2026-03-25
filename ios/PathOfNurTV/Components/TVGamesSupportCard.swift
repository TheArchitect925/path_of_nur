import SwiftUI

struct TVGamesSupportCardView: View {
  let item: TVGamesSupportCard

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      Text(item.eyebrow)
        .font(TVTypography.heroEyebrow)
        .foregroundColor(TVTheme.focus)

      Text(item.title)
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.textPrimary)

      Text(item.subtitle)
        .font(TVTypography.sectionSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(4)

      Spacer(minLength: 0)

      Label(item.supportingLine, systemImage: item.systemImage)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .labelStyle(.titleAndIcon)
        .lineLimit(3)
    }
    .frame(width: 360, alignment: .leading)
    .frame(minHeight: 240, alignment: .topLeading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: false, emphasized: false)
  }
}
