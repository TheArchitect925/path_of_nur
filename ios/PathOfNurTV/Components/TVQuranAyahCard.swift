import SwiftUI

struct TVQuranAyahCard: View {
  let ayah: TVQuranAyah
  let isSelected: Bool
  let isPlaying: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      HStack {
        Text(String(format: NSLocalizedString("Ayah %d", comment: ""), ayah.ayahNumber))
          .font(.system(size: 16, weight: .bold, design: .rounded))
          .foregroundStyle(TVTheme.textSecondary)

        Spacer()

        if isPlaying {
          Image(systemName: "speaker.wave.2.fill")
            .foregroundStyle(TVTheme.accentStrong)
        } else if isSelected {
          Image(systemName: "play.circle.fill")
            .foregroundStyle(TVTheme.accentStrong)
        }
      }

      Text(ayah.arabic)
        .font(.system(size: 30, weight: .medium, design: .serif))
        .foregroundStyle(TVTheme.textPrimary)
        .multilineTextAlignment(.trailing)
        .frame(maxWidth: .infinity, alignment: .trailing)

      Text(ayah.transliteration)
        .font(.system(size: 18, weight: .medium, design: .serif))
        .italic()
        .foregroundStyle(TVTheme.textMuted)

      Text(ayah.translation)
        .font(.system(size: 20, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(24)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .fill(isSelected ? TVTheme.surfaceElevated : TVTheme.surface)
    )
    .tvFocusableCard()
  }
}
