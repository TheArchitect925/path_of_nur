import SwiftUI

struct TVFavoritesSupportCardView: View {
  let item: TVFavoritesSupportCard

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      Text(item.eyebrow)
        .font(TVTypography.heroEyebrow)
        .foregroundColor(TVTheme.focus)
        .tvReadableBody()

      Text(item.title)
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(item.subtitle)
        .font(TVTypography.sectionSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(4)
        .tvReadableBody()

      Spacer(minLength: 0)

      Label(item.supportingLine, systemImage: item.systemImage)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .labelStyle(.titleAndIcon)
        .lineLimit(3)
        .tvReadableBody()
    }
    .frame(width: 360, alignment: .leading)
    .frame(minHeight: 240, alignment: .topLeading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: false, emphasized: false)
    .tvCombinedAccessibility(label: item.title, hint: item.subtitle)
  }
}
