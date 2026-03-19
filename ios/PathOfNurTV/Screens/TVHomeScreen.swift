import SwiftUI

struct TVHomeScreen: View {
  @ObservedObject var viewModel: TVHomeViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
        TVHeroCard(
          eyebrow: viewModel.hero.eyebrow,
          title: viewModel.hero.title,
          subtitle: viewModel.hero.subtitle,
          supportingLine: viewModel.hero.supportingLine
        )

        TVSectionHeader(
          title: NSLocalizedString("Prayer Times", comment: ""),
          subtitle: NSLocalizedString(
            "Prayer times follow the same calm emphasis as mobile: one highlighted current or next prayer, then the full day.",
            comment: ""
          )
        )

        VStack(alignment: .leading, spacing: 18) {
          _summaryCard(
            title: viewModel.prayerSummaryLine,
            subtitle: viewModel.prayerSummaryDetail
          )

          LazyVGrid(
            columns: [
              GridItem(.flexible(), spacing: 18),
              GridItem(.flexible(), spacing: 18),
            ],
            spacing: 18
          ) {
            ForEach(viewModel.prayerTimes) { prayer in
              TVPrayerTimeCard(prayer: prayer)
            }
          }
        }

        TVSectionHeader(
          title: NSLocalizedString("Today's Light", comment: ""),
          subtitle: NSLocalizedString(
            "Home keeps the prayer-first shape of the mobile app, with the Qur'an close at hand.",
            comment: ""
          )
        )

        _verseCard

        TVSectionHeader(
          title: NSLocalizedString("Featured Qur'an paths", comment: ""),
          subtitle: NSLocalizedString(
            "Open the same Qur'an space from the home surface.",
            comment: ""
          )
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            Button {
              appViewModel.selectedTab = .quran
            } label: {
              TVActionCard(
                title: NSLocalizedString("Continue Reading", comment: ""),
                subtitle: String(
                  format: NSLocalizedString("Continue with %@ %d:%d", comment: ""),
                  viewModel.continueReading.surahName,
                  viewModel.continueReading.surahNumber,
                  viewModel.continueReading.ayahNumber
                ),
                systemImage: "book.closed.fill"
              )
            }
            .buttonStyle(.plain)

            ForEach(viewModel.actions) { item in
              Button {
                if item.id == "home_quran" {
                  appViewModel.selectedTab = .quran
                }
              } label: {
                TVShelfCard(item: item)
              }
              .buttonStyle(.plain)
            }
          }
          .padding(.vertical, 8)
        }
      }
      .padding(TVTheme.outerPadding)
    }
    .background(TVBackgroundView())
    .navigationTitle(NSLocalizedString("Home", comment: ""))
  }

  private func _summaryCard(title: String, subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(.system(size: 34, weight: .bold, design: .serif))
        .foregroundStyle(TVTheme.textPrimary)

      Text(subtitle)
        .font(.system(size: 20, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(28)
    .background(
      RoundedRectangle(cornerRadius: 34, style: .continuous)
        .fill(TVTheme.surface)
    )
  }

  private var _verseCard: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(viewModel.verse.arabic)
        .font(.system(size: 34, weight: .medium, design: .serif))
        .foregroundStyle(TVTheme.textPrimary)
        .frame(maxWidth: .infinity, alignment: .trailing)

      Text(viewModel.verse.transliteration)
        .font(.system(size: 18, weight: .medium, design: .serif))
        .italic()
        .foregroundStyle(TVTheme.textMuted)

      Text(viewModel.verse.translation)
        .font(.system(size: 21, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)

      Text(viewModel.verse.locationLabel)
        .font(.system(size: 15, weight: .semibold, design: .rounded))
        .foregroundStyle(TVTheme.accentStrong)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(28)
    .background(
      RoundedRectangle(cornerRadius: 34, style: .continuous)
        .fill(TVTheme.surface)
    )
  }
}
