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

        VStack(alignment: .leading, spacing: 18) {
          Text(viewModel.summaryLine)
            .font(TVTypography.summaryTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          Text(viewModel.detailLine)
            .font(TVTypography.featureSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .tvReadableBody()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(TVTheme.cardPadding)
        .tvSurfaceCard(elevated: true, emphasized: true)
        .tvFocusableCard()
        .focused($focusedSection, equals: TVFocusSectionId.prayerCurrentNext)
        .tvCombinedAccessibility(label: viewModel.summaryLine, hint: viewModel.detailLine)

        TVSectionHeader(
          title: viewModel.scheduleTitle,
          subtitle: ""
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.prayerTimes.enumerated()), id: \.element.id) { index, prayer in
              TVPrayerTimeCard(prayer: prayer)
                .frame(width: 320)
                .focused(
                  $focusedSection,
                  equals: index == 0 ? TVFocusSectionId.prayerSchedule : "prayer.schedule.\(prayer.id)"
                )
            }
          }
          .padding(.vertical, 8)
          .padding(.horizontal, TVTheme.railBleed)
        }
        .padding(.horizontal, -TVTheme.railBleed)
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
      if section.hasPrefix("prayer.currentNext") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.prayerCurrentNext, for: .prayer)
      } else if section.hasPrefix("prayer.schedule") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.prayerSchedule, for: .prayer)
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
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
