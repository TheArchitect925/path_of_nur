import SwiftUI

struct TVQuranBrowseCollectionCard: View {
  let collection: TVQuranBrowseCollection
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(collection.eyebrow.uppercased())
        .font(TVTypography.badge)
        .foregroundColor(TVTheme.focus)

      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 8) {
          Text(collection.title)
            .font(TVTypography.featureTitle)
            .foregroundColor(TVTheme.textPrimary)

          Text(collection.subtitle)
            .font(TVTypography.featureSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(2)
        }

        Spacer()

        Image(systemName: collection.systemImage)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      Text(collection.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(2)
    }
    .frame(width: 330, height: 190, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected)
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(isSelected ? TVTheme.accentSoft : .clear, lineWidth: isSelected ? 2 : 0)
    )
    .tvFocusableCard()
  }
}
