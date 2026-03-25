import SwiftUI

struct TVHouseholdSupportCardView: View {
  let item: TVHouseholdSupportCard

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      Label(item.eyebrow, systemImage: item.systemImage)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.focus)

      Text(item.title)
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(item.subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .tvReadableBody()
    }
    .frame(width: 400, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: false)
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: item.title,
      hint: item.subtitle
    )
  }
}
