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
          subtitle: viewModel.continueJourneySummarySubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.continueJourneyItems.enumerated()), id: \.element.id) { index, item in
              let focusID = index == 0
                  ? TVFocusSectionId.homeContinueJourney
                  : "home.continueJourney.\(item.id)"

              Button {
                _handleContinueJourneyTap(for: item.id)
              } label: {
                TVContinueJourneyCard(item: item)
              }
              .buttonStyle(.plain)
              .focused($focusedSection, equals: focusID)
            }
          }
          .padding(.vertical, 8)
        }

        TVSectionHeader(
          title: tvLocalized("Prayer Times"),
          subtitle: viewModel.prayerSectionSubtitle
        )

        VStack(alignment: .leading, spacing: TVTheme.blockSpacing) {
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
          title: tvLocalized("Today's Light"),
          subtitle: viewModel.dailyLightSubtitle
        )

        _verseCard

        TVSectionHeader(
          title: tvLocalized("Featured Qur'an paths"),
          subtitle: tvLocalized("Open the same Qur'an space from the home surface.")
        )

        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: TVTheme.railSpacing) {
            Button {
              appViewModel.navigate(to: .quran, preferredColumn: .content)
            } label: {
              TVActionCard(
                title: tvLocalized("Continue Reading"),
                subtitle: tvLocalized(
                  "Continue with %@ %d:%d",
                  viewModel.continueReading.surahName,
                  viewModel.continueReading.surahNumber,
                  viewModel.continueReading.ayahNumber
                ),
                systemImage: "book.closed.fill"
              )
            }
            .buttonStyle(.plain)
            .focused($focusedSection, equals: TVFocusSectionId.homeContinueJourney)

            ForEach(viewModel.actions) { item in
              Button {
                if item.id == "home_quran" {
                  appViewModel.navigate(to: .quran, preferredColumn: .content)
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
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
  }

  private func _summaryCard(title: String, subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(subtitle)
        .font(TVTypography.summaryLine)
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()
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
          .frame(maxWidth: .infinity, alignment: .trailing)
          .tvReadableArabic()

        Text(viewModel.verse.transliteration)
          .font(TVTypography.bodySecondary.italic())
          .italic()
          .foregroundColor(TVTheme.textMuted)
          .tvReadableBody()

        Text(viewModel.verse.translation)
          .font(TVTypography.body)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()

        Text(viewModel.verse.locationLabel)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.accentStrong)
          .tvReadableBody()
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(TVTheme.cardPadding)
      .tvSurfaceCard(elevated: true)
    }
    .buttonStyle(.plain)
    .focused($focusedSection, equals: TVFocusSectionId.homeVerse)
    .tvFocusableCard()
    .accessibilityLabel(viewModel.verse.locationLabel)
    .accessibilityHint(tvLocalized("Opens this ayah in the Qur'an route."))
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
    case "continue_reading", "resume_listening":
      appViewModel.navigate(to: .quran, preferredColumn: .content)
    case "prayer_focus":
      focusedSection = TVFocusSectionId.homeContinueJourney
    default:
      appViewModel.navigate(to: .quran, preferredColumn: .content)
    }
  }
}
