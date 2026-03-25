import SwiftUI

struct TVQuranAyahCard: View {
  let ayah: TVQuranAyah
  let isSelected: Bool
  let isPlaying: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      HStack {
        Text(tvLocalized("Ayah %d", ayah.ayahNumber))
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()

        Spacer()

        if isPlaying {
          Image(systemName: "speaker.wave.2.fill")
            .foregroundColor(TVTheme.accentStrong)
        } else if isSelected {
          Image(systemName: "play.circle.fill")
            .foregroundColor(TVTheme.accentStrong)
        }
      }

      Text(ayah.arabic)
        .font(TVTypography.arabicAyah)
        .foregroundColor(TVTheme.textPrimary)
        .multilineTextAlignment(.trailing)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .tvReadableArabic()

      Text(ayah.transliteration)
        .font(TVTypography.bodySecondary.italic())
        .italic()
        .foregroundColor(TVTheme.textMuted)
        .tvReadableBody()

      Text(ayah.translation)
        .font(TVTypography.body)
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(24)
    .tvSurfaceCard(elevated: isSelected, emphasized: isSelected || isPlaying)
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(
          isPlaying
            ? TVTheme.accentStrong
            : (isSelected ? TVTheme.accentSoft : .clear),
          lineWidth: isPlaying ? 3 : (isSelected ? 1.5 : 0)
        )
    )
    .shadow(
      color: isPlaying ? TVTheme.accentStrong.opacity(0.28) : .clear,
      radius: isPlaying ? 18 : 0,
      x: 0,
      y: 6
    )
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: tvLocalized("Ayah %d", ayah.ayahNumber),
      hint: ayah.translation,
      value: isPlaying ? tvLocalized("Audio is playing") : (isSelected ? tvLocalized("Selected") : nil)
    )
  }
}
