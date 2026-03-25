import SwiftUI

struct TVQuranSurahRow: View {
  let surah: TVQuranSurah
  let isSelected: Bool

  var body: some View {
    HStack(spacing: 16) {
      Text("\(surah.number)")
        .font(TVTypography.summaryLine)
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: 42)

      VStack(alignment: .leading, spacing: 4) {
        Text(surah.transliteratedName)
          .font(TVTypography.featureTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text("\(surah.englishName) • \(surah.revelationPlace) • \(surah.verseCount)")
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textSecondary)
      }

      Spacer()

      Text(surah.arabicName)
        .font(TVTypography.arabicSupport)
        .foregroundColor(TVTheme.textSecondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(22)
    .tvSurfaceCard(elevated: isSelected, emphasized: isSelected)
    .tvFocusableCard()
  }
}
