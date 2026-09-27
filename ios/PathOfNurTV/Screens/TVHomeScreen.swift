import SwiftUI

struct TVHomeScreen: View {
  @ObservedObject var viewModel: TVHomeViewModel
  /// Home goes on from where the Qur'an was left, and shows its verse of
  /// the day.
  @ObservedObject var quran: TVQuranViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @FocusState private var focusedSection: String?

  var body: some View {
    GeometryReader { geometry in
      page(in: geometry.size)
    }
  }

  private func page(in screen: CGSize) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
        TVHeroCard(
          eyebrow: viewModel.hero.eyebrow,
          title: viewModel.hero.title,
          subtitle: viewModel.hero.subtitle,
          supportingLine: viewModel.hero.supportingLine
        )

        TVSectionHeader(
          title: viewModel.continueJourneySummaryTitle,
          subtitle: ""
        )

        ScrollView(.horizontal, showsIndicators: false) {
          // Not lazy, here or in the prayer times below. What is lazy and
          // below the screen's edge is not yet there for the focus to move
          // to, and a press down goes past it to whatever is.
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(continueJourneyItems.enumerated()), id: \.element.id) { index, item in
              let focusID = index == 0
                  ? TVFocusSectionId.homeContinueJourney
                  : "home.continueJourney.\(item.id)"

              Button {
                _handleContinueJourneyTap(for: item.id)
              } label: {
                TVContinueJourneyCard(item: item)
              }
              .buttonStyle(TVCardButtonStyle())
              .tvFocusID($focusedSection, focusID)
            }
          }
          .padding(TVTheme.railBleed)
        }
        .tvRail()

        TVSectionHeader(
          title: tvLocalized("Prayer times"),
          subtitle: ""
        )

        VStack(alignment: .leading, spacing: TVTheme.blockSpacing) {
          _summaryCard(
            title: viewModel.prayerSummaryLine,
            subtitle: viewModel.prayerSummaryDetail
          )

          VStack(spacing: 18) {
            ForEach(_prayerRows, id: \.first?.id) { row in
              HStack(alignment: .top, spacing: 18) {
                ForEach(row) { prayer in
                  TVPrayerTimeCard(prayer: prayer)
                    .tvFocusID($focusedSection, "home.prayer.\(prayer.id)")
                }
                // The last row of an odd number keeps its card to one column.
                if row.count == 1 {
                  Color.clear.frame(maxWidth: .infinity, maxHeight: 1)
                }
              }
            }
          }
        }

        TVSectionHeader(
          title: tvLocalized("Today’s verse"),
          subtitle: ""
        )

        _verseCard(in: screen)
      }
      .padding(TVTheme.outerPadding)
    }
    .tvPreferredFocus($focusedSection, appViewModel.preferredContentSection(for: .home))
    .onAppear {
      quran.refreshVerseOfTheDay()
      restorePreferredFocus()
    }
    .onChange(of: appViewModel.contentFocusRequest) { _ in
      restorePreferredFocus()
    }
    .onChange(of: focusedSection) { section in
      guard let section else { return }
      if section.hasPrefix("home.continueJourney") {
        appViewModel.markContentSectionFocused(
          TVFocusSectionId.homeContinueJourney,
          for: .home
        )
      } else {
        appViewModel.markContentSectionFocused(section, for: .home)
      }
    }
  }

  /// The prayer times two to a row.
  private var _prayerRows: [[TVPrayerTime]] {
    let times = viewModel.prayerTimes
    return stride(from: 0, to: times.count, by: 2).map { start in
      Array(times[start..<min(start + 2, times.count)])
    }
  }

  private func _summaryCard(title: String, subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      if !subtitle.isEmpty {
        Text(subtitle)
          .font(TVTypography.summaryLine)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true)
    .tvCombinedAccessibility(label: title, hint: subtitle)
  }

  private var continueJourneyItems: [TVContinueJourneyItem] {
    TVSeedRepository.homeContinueJourneyItems(quran: quran)
  }

  // What the verse's card puts around the verse: its padding, the line that
  // says where the verse is from, and the line that says there is more.
  private static let verseLineHeight: CGFloat = 22
  private static let verseChrome =
      TVTheme.cardPadding * 2 + (verseLineHeight + TVQuranAyahMetrics.cardSpacing) * 2

  /// The verse of the day, which opens in the reader. It is set to fit the
  /// screen, since a card taller than the screen cannot be read to its end.
  private func _verseCard(in screen: CGSize) -> some View {
    let verse = quran.dailyVerse
    let textWidth = screen.width - TVTheme.outerPadding * 2 - TVTheme.cardPadding * 2
    let fitted = TVQuranAyahPlanner.homePlan(
      for: TVQuranAyah(
        id: "\(verse.surahNumber):\(verse.ayahNumber)",
        surahNumber: verse.surahNumber,
        ayahNumber: verse.ayahNumber,
        arabic: verse.arabic,
        transliteration: verse.transliteration,
        translation: verse.translation
      ),
      screen: screen,
      textWidth: textWidth,
      chrome: Self.verseChrome,
      inset: TVTheme.railBleed,
      focusScale: TVTheme.focusScale,
      language: Locale.current.languageCode ?? "en"
    )

    return Button {
      appViewModel.openQuran(
        at: TVQuranPlace(surahNumber: verse.surahNumber, ayahNumber: verse.ayahNumber)
      )
    } label: {
      VStack(alignment: .leading, spacing: TVQuranAyahMetrics.cardSpacing) {
        if let beginning = fitted.parts.first {
          TVQuranAyahText(part: beginning, metrics: fitted.metrics)
        }

        if !fitted.isWhole {
          Text(tvLocalized("The rest is in the reader."))
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.textMuted)
            .frame(height: Self.verseLineHeight)
        }

        Text(verse.locationLabel)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.accentStrong)
          .frame(height: Self.verseLineHeight)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(TVTheme.cardPadding)
      .tvSurfaceCard(elevated: true)
    }
    .buttonStyle(TVCardButtonStyle())
    .tvFocusID($focusedSection, TVFocusSectionId.homeVerse)
    .accessibilityLabel(verse.locationLabel)
    .accessibilityValue(verse.translation)
    .accessibilityHint(tvLocalized("Opens the Qur’an."))
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .home, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .home)
    }
  }

  private func _handleContinueJourneyTap(for itemId: String) {
    switch itemId {
    case "continue_reading":
      appViewModel.openQuran(at: quran.continueReadingPlace)
    case "resume_listening":
      appViewModel.openQuran(at: quran.continueReadingPlace, listening: true)
    case "dhikr_routines":
      appViewModel.navigate(to: .dhikr, preferredColumn: .content)
    default:
      break
    }
  }
}
