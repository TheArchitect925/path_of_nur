import SwiftUI

struct TVSavedItemCardView: View {
  let item: TVSavedItemCard
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(item.eyebrow.uppercased())
        .font(TVTypography.badge)
        .foregroundColor(TVTheme.focus)
        .tvReadableBody()

      HStack(alignment: .top, spacing: 14) {
        VStack(alignment: .leading, spacing: 8) {
          Text(item.title)
            .font(TVTypography.sectionTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          Text(item.subtitle)
            .font(TVTypography.sectionSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(3)
            .tvReadableBody()
        }

        Spacer(minLength: 0)

        Image(systemName: item.systemImage)
          .font(.system(size: 22, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(2)
        .tvReadableBody()

      Text(item.detailLine)
        .font(TVTypography.summaryLine)
        .foregroundColor(TVTheme.textPrimary)
        .lineLimit(2)
        .tvReadableBody()

      HStack(spacing: 10) {
        ForEach(item.tags, id: \.self) { tag in
          Text(tag)
            .font(TVTypography.badge)
            .foregroundColor(TVTheme.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
              Capsule(style: .continuous)
                .fill(TVTheme.surfaceSoft)
            )
        }
      }
    }
    .frame(width: 390, alignment: .leading)
    .frame(minHeight: 270, alignment: .topLeading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected)
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(isSelected ? TVTheme.accentSoft : .clear, lineWidth: isSelected ? 2 : 0)
    )
    .tvFocusableCard()
    .tvCombinedAccessibility(label: item.title, hint: item.subtitle, value: item.detailLine)
  }
}
