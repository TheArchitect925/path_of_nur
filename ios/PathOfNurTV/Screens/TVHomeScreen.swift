import SwiftUI

struct TVHomeScreen: View {
  @ObservedObject var viewModel: TVHomeViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @FocusState private var focusedSection: String?

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
          title: viewModel.continueJourneySummaryTitle,
          subtitle: ""
        )

        ScrollView(.horizontal, showsIndicators: false) {
          // Not lazy, here or in the prayer times below. What is lazy and
          // below the screen's edge is not yet there for the focus to move
          // to, and a press down goes past it to whatever is.
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.continueJourneyItems.enumerated()), id: \.element.id) { index, item in
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

        _verseCard
      }
      .padding(TVTheme.outerPadding)
    }
    .tvPreferredFocus($focusedSection, appViewModel.preferredContentSection(for: .home))
    .onAppear {
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

  private var _verseCard: some View {
    Button {
      appViewModel.navigate(to: .quran, preferredColumn: .content)
    } label: {
      VStack(alignment: .leading, spacing: 14) {
        Text(viewModel.verse.arabic)
          .font(TVTypography.arabicHero)
          .foregroundColor(TVTheme.textPrimary)
          .tvArabicLine()
          .tvReadableArabic()

        if !viewModel.verse.transliteration.isEmpty {
          Text(viewModel.verse.transliteration)
            .font(TVTypography.bodySecondary.italic())
            .italic()
            .foregroundColor(TVTheme.textMuted)
            .tvReadableBody()
        }

        if !viewModel.verse.translation.isEmpty {
          Text(viewModel.verse.translation)
            .font(TVTypography.body)
            .foregroundColor(TVTheme.textSecondary)
            .tvReadableBody()
        }

        Text(viewModel.verse.locationLabel)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.accentStrong)
          .tvReadableBody()
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(TVTheme.cardPadding)
      .tvSurfaceCard(elevated: true)
    }
    .buttonStyle(TVCardButtonStyle())
    .tvFocusID($focusedSection, TVFocusSectionId.homeVerse)
    .tvFocusableCard()
    .accessibilityLabel(viewModel.verse.locationLabel)
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
    case "resume_listening":
      appViewModel.navigate(to: .quran, preferredColumn: .content)
      appViewModel.quranViewModel.openListeningMode()
    case "dhikr_routines":
      appViewModel.navigate(to: .dhikr, preferredColumn: .content)
    default:
      appViewModel.navigate(to: .quran, preferredColumn: .content)
    }
  }
}
