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
          subtitle: viewModel.currentNextSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            Text(viewModel.summaryLine)
              .font(TVTypography.summaryTitle)
              .foregroundColor(TVTheme.textPrimary)

            Text(viewModel.detailLine)
              .font(TVTypography.featureSubtitle)
              .foregroundColor(TVTheme.textSecondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(TVTheme.cardPadding)
          .tvSurfaceCard(elevated: true, emphasized: true)
          .tvFocusableCard()
          .focused($focusedSection, equals: TVFocusSectionId.prayerCurrentNext)

          VStack(alignment: .leading, spacing: 14) {
            Text(tvLocalized("Prayer route note"))
              .font(TVTypography.summaryTitle)
              .foregroundColor(TVTheme.textPrimary)

            Text(tvLocalized("Prayer on TV should lead with clarity and presence: current, next, then the day without burying the room in settings or calculations."))
              .font(TVTypography.detail)
              .foregroundColor(TVTheme.textSecondary)
          }
          .frame(width: 380, alignment: .leading)
          .padding(TVTheme.cardPadding)
          .tvSurfaceCard(elevated: true, emphasized: false)
        }

        TVSectionHeader(
          title: viewModel.scheduleTitle,
          subtitle: viewModel.scheduleSubtitle
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
        }

        TVSectionHeader(
          title: viewModel.companionTitle,
          subtitle: viewModel.companionSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.focusCards.enumerated()), id: \.element.id) { index, item in
              TVPrayerFocusCardView(item: item)
                .focused(
                  $focusedSection,
                  equals: index == 0 ? TVFocusSectionId.prayerCompanion : "prayer.companion.\(item.id)"
                )
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
      if section.hasPrefix("prayer.currentNext") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.prayerCurrentNext, for: .prayer)
      } else if section.hasPrefix("prayer.schedule") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.prayerSchedule, for: .prayer)
      } else if section.hasPrefix("prayer.companion") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.prayerCompanion, for: .prayer)
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
