import SwiftUI

struct TVQuranSurahRow: View {
  let surah: TVQuranSurah
  let isSelected: Bool

  var body: some View {
    HStack(spacing: 16) {
      Text("\(surah.number)")
        .font(.system(size: 22, weight: .bold, design: .rounded))
        .foregroundStyle(TVTheme.textPrimary)
        .frame(width: 42)

      VStack(alignment: .leading, spacing: 4) {
        Text(surah.transliteratedName)
          .font(.system(size: 24, weight: .bold, design: .serif))
          .foregroundStyle(TVTheme.textPrimary)

        Text("\(surah.englishName) • \(surah.revelationPlace) • \(surah.verseCount)")
          .font(.system(size: 16, weight: .medium, design: .rounded))
          .foregroundStyle(TVTheme.textSecondary)
      }

      Spacer()

      Text(surah.arabicName)
        .font(.system(size: 24, weight: .semibold, design: .serif))
        .foregroundStyle(TVTheme.textSecondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(22)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .fill(isSelected ? TVTheme.surfaceElevated : TVTheme.surface)
    )
    .tvFocusableCard()
  }
}
