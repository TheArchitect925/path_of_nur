import SwiftUI

struct TVArabicLetterGroupCard: View {
  let item: TVArabicLetterGroup
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(item.eyebrow.uppercased())
        .font(TVTypography.badge)
        .foregroundColor(TVTheme.focus)

      Text(item.title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)

      Text(item.subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(3)

      HStack(spacing: 16) {
        ForEach(item.letters, id: \.self) { letter in
          Text(letter)
            .font(TVTypography.arabicBody)
            .foregroundColor(TVTheme.accentStrong)
        }
      }

      Spacer(minLength: 0)

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(3)
    }
    .frame(width: 380, height: 270, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected)
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(isSelected ? TVTheme.accentSoft : .clear, lineWidth: isSelected ? 2 : 0)
    )
    .tvFocusableCard()
  }
}
