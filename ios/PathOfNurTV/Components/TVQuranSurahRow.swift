import SwiftUI

struct TVQuranSurahRow: View {
  let surah: TVQuranSurah
  let isSelected: Bool

  var body: some View {
    HStack(spacing: 14) {
      Text("\(surah.number)")
        .font(TVTypography.summaryLine)
        .foregroundColor(isSelected ? TVTheme.accentStrong : TVTheme.textPrimary)
        .frame(width: 44)

      VStack(alignment: .leading, spacing: 4) {
        Text(surah.transliteratedName)
          .font(TVTypography.listTitle)
          .foregroundColor(TVTheme.textPrimary)
          .lineLimit(1)
          .minimumScaleFactor(0.8)

        Text("\(surah.englishName) • \(surah.revelationPlace) • \(surah.verseCount)")
          .font(TVTypography.caption)
          .foregroundColor(TVTheme.textSecondary)
          .lineLimit(2)
      }

      Spacer(minLength: 8)

      Text(surah.arabicName)
        .font(TVTypography.arabicSupport)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(1)
        .fixedSize()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 18)
    .padding(.vertical, 14)
    .tvSurfaceCard(elevated: isSelected, emphasized: isSelected)
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: "\(surah.number). \(surah.transliteratedName)",
      hint: "\(surah.englishName), \(surah.revelationPlace), \(surah.verseCount)",
      value: isSelected ? tvLocalized("Selected") : nil
    )
  }
}
