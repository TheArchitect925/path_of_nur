import SwiftUI

struct TVPrayerScreen: View {
  @ObservedObject var viewModel: TVPrayerViewModel
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
          title: viewModel.currentNextTitle,
          subtitle: ""
        )

        if viewModel.prayerTimes.isEmpty {
          Button {
            appViewModel.markContentSectionFocused(TVFocusSectionId.settingsPrayer, for: .settings)
            appViewModel.navigate(to: .settings, preferredColumn: .content)
          } label: {
            summaryCard
          }
          .buttonStyle(TVCardButtonStyle())
          .tvFocusID($focusedSection, TVFocusSectionId.prayerCurrentNext)
        } else {
          summaryCard
            .tvFocusableCard()
            .tvFocusID($focusedSection, TVFocusSectionId.prayerCurrentNext)

          TVSectionHeader(
            title: viewModel.scheduleTitle,
            subtitle: ""
          )

          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: TVTheme.railSpacing) {
              ForEach(Array(viewModel.prayerTimes.enumerated()), id: \.element.id) { index, prayer in
                TVPrayerTimeCard(prayer: prayer)
                  .frame(width: 320)
                  .tvFocusID($focusedSection, scheduleFocusID(prayer, at: index))
              }
            }
            .padding(TVTheme.railBleed)
          }
          .focusSection()
          // The day is entered at the prayer the card above speaks of, not
          // at whichever card is under the middle of the screen.
          .tvPreferredFocus($focusedSection, prayerInHandFocusID)
          .tvRail()
        }
      }
      .padding(TVTheme.outerPadding)
    }
    .tvPreferredFocus($focusedSection, appViewModel.preferredContentSection(for: .prayer))
    .onAppear {
      restorePreferredFocus()
    }
    .onChange(of: appViewModel.contentFocusRequest) { _ in
      restorePreferredFocus()
    }
    .onChange(of: focusedSection) { section in
      guard let section, section.hasPrefix("prayer.") else { return }
      // The control itself, so that the focus returns to it and not to the
      // first of its row.
      appViewModel.markContentSectionFocused(section, for: .prayer)
    }
  }

  private func scheduleFocusID(_ prayer: TVPrayerTime, at index: Int) -> String {
    index == 0 ? TVFocusSectionId.prayerSchedule : "prayer.schedule.\(prayer.id)"
  }

  /// The prayer the card above speaks of: the one whose time it is, or the
  /// one that is next when it is no prayer's time.
  private var prayerInHandFocusID: String? {
    let times = viewModel.prayerTimes
    guard let index = times.firstIndex(where: \.isCurrent) ?? times.firstIndex(where: \.isNext) else {
      return times.isEmpty ? nil : TVFocusSectionId.prayerSchedule
    }
    return scheduleFocusID(times[index], at: index)
  }

  private var summaryCard: some View {
    VStack(alignment: .leading, spacing: 18) {
      Text(viewModel.summaryLine)
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      if !viewModel.detailLine.isEmpty {
        Text(viewModel.detailLine)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: true)
    .tvCombinedAccessibility(label: viewModel.summaryLine, hint: viewModel.detailLine)
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .prayer, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .prayer)
    }
  }
}
