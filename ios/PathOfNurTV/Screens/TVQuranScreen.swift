import SwiftUI

struct TVQuranScreen: View {
  @ObservedObject var viewModel: TVQuranViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
        TVHeroCard(
          eyebrow: NSLocalizedString("Qur'an", comment: ""),
          title: NSLocalizedString("Qur'an", comment: ""),
          subtitle: NSLocalizedString(
            "One entry for reading, browsing, and playback built from the current mobile Qur'an direction.",
            comment: ""
          ),
          supportingLine: NSLocalizedString(
            "Qur'an keeps the same overall direction as mobile: continue reading, today's verse, browse, and playback.",
            comment: ""
          )
        )

        HStack(alignment: .top, spacing: 20) {
          _summaryCard(
            title: NSLocalizedString("Continue with the Qur'an", comment: ""),
            line: viewModel.continueReadingLine,
            detail: NSLocalizedString(
              "The Qur'an page follows the mobile direction: continue reading, daily light, browse, and playback.",
              comment: ""
            )
          )

          _summaryCard(
            title: NSLocalizedString("Today's Light", comment: ""),
            line: viewModel.dailyVerse.locationLabel,
            detail: viewModel.dailyVerse.translation
          )
        }

        TVQuranPlaybackCard(viewModel: viewModel)

        HStack(alignment: .top, spacing: 28) {
          VStack(alignment: .leading, spacing: 16) {
            TVSectionHeader(
              title: NSLocalizedString("Browse Surahs", comment: ""),
              subtitle: NSLocalizedString(
                "Reader selection follows the current tvOS staged Qur'an set for this first pass.",
                comment: ""
              )
            )

            VStack(spacing: 14) {
              ForEach(viewModel.surahs) { surah in
                Button {
                  viewModel.selectSurah(surah)
                } label: {
                  TVQuranSurahRow(
                    surah: surah,
                    isSelected: surah.id == viewModel.selectedSurah.id
                  )
                }
                .buttonStyle(.plain)
              }
            }
          }
          .frame(width: 540, alignment: .leading)

          VStack(alignment: .leading, spacing: 16) {
            TVSectionHeader(
              title: NSLocalizedString("Reader", comment: ""),
              subtitle: viewModel.readerSubtitle
            )

            VStack(spacing: 16) {
              ForEach(Array(viewModel.selectedAyahs.enumerated()), id: \.element.id) { index, ayah in
                Button {
                  viewModel.selectAyah(at: index)
                } label: {
                  TVQuranAyahCard(
                    ayah: ayah,
                    isSelected: index == viewModel.selectedAyahIndex,
                    isPlaying: viewModel.isPlaying && index == viewModel.selectedAyahIndex
                  )
                }
                .buttonStyle(.plain)
              }
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .padding(TVTheme.outerPadding)
    }
    .background(TVBackgroundView())
    .navigationTitle(NSLocalizedString("Qur'an", comment: ""))
  }

  private func _summaryCard(title: String, line: String, detail: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(.system(size: 28, weight: .bold, design: .serif))
        .foregroundStyle(TVTheme.textPrimary)

      Text(line)
        .font(.system(size: 20, weight: .semibold, design: .rounded))
        .foregroundStyle(TVTheme.accentStrong)

      Text(detail)
        .font(.system(size: 17, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
        .lineLimit(4)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(24)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .fill(TVTheme.surface)
    )
  }
}
