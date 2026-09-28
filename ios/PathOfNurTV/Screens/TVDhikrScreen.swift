import SwiftUI

struct TVDhikrScreen: View {
  @ObservedObject var viewModel: TVDhikrViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @EnvironmentObject private var themeController: TVThemeController
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
          title: viewModel.routinesTitle,
          subtitle: viewModel.routinesSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.routines.enumerated()), id: \.element.id) { index, routine in
              Button {
                viewModel.openRoutine(routine)
              } label: {
                routineCard(routine)
              }
              .buttonStyle(TVCardButtonStyle())
              .tvFocusID($focusedSection, index == 0 ? TVFocusSectionId.dhikrRoutines : "dhikr.routines.\(routine.id)")
            }
          }
          .padding(TVTheme.railBleed)
        }
        .tvRail()

        TVSectionHeader(
          title: viewModel.phrasesTitle,
          subtitle: viewModel.phrasesSubtitle
        )


        // A phrase opens in the player the routines open in, and is counted
        // there.
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.phrases.enumerated()), id: \.element.id) { index, phrase in
              let done = viewModel.isRoutineDoneToday(phrase)
              Button {
                viewModel.openRoutine(phrase)
              } label: {
                TVDhikrPhraseCard(
                  phrase: phrase,
                  line: routineLine(phrase, done: done),
                  isDone: done
                )
              }
              .buttonStyle(TVCardButtonStyle())
              .tvFocusID($focusedSection, index == 0 ? TVFocusSectionId.dhikrPhrases : "dhikr.\(phrase.id)")
            }
          }
          .padding(TVTheme.railBleed)
        }
        .tvRail()

        HStack(spacing: 14) {
          Text(tvLocalized("Count each phrase to"))
            .font(TVTypography.figtreeMedium(22))
            .foregroundColor(TVTheme.textSecondary)
          ForEach(TVDhikrViewModel.phraseTargets, id: \.self) { target in
            let isChosen = viewModel.phraseTarget == target
            Button {
              viewModel.selectPhraseTarget(target)
            } label: {
              Text("\(target)")
                .font(TVTypography.figtreeMedium(22))
                .foregroundColor(isChosen ? TVTheme.prayerCurrentText : TVTheme.textPrimary)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(isChosen ? TVTheme.prayerCurrent : TVTheme.surfaceSoft, in: Capsule())
            }
            .buttonStyle(TVCardButtonStyle(shape: .capsule))
            .tvFocusID($focusedSection, "dhikr.target.\(target)")
            .accessibilityValue(isChosen ? tvLocalized("Selected") : "")
          }
        }
        .focusSection()
      }
      .padding(TVTheme.outerPadding)
    }
    .tvPreferredFocus($focusedSection, appViewModel.preferredContentSection(for: .dhikr))
    .onAppear {
      viewModel.refreshDay()
      restorePreferredFocus()
    }
    .onChange(of: appViewModel.contentFocusRequest) { _ in
      restorePreferredFocus()
    }
    .onChange(of: focusedSection) { section in
      guard let section, section.hasPrefix("dhikr.") else { return }
      // The control itself, so that the focus returns to it and not to the
      // first of its row.
      appViewModel.markContentSectionFocused(section, for: .dhikr)
    }
    .fullScreenCover(isPresented: $viewModel.isRoutinePlayerPresented) {
      TVDhikrRoutinePlayerScreen(viewModel: viewModel)
        .environmentObject(themeController)
    }
  }

  private func routineCard(_ routine: TVDhikrRoutine) -> some View {
    let done = viewModel.isRoutineDoneToday(routine)
    return VStack(alignment: .leading, spacing: 14) {
      HStack(alignment: .top) {
        Text(tvLocalized("Routine").uppercased())
          .font(TVTypography.badge)
          .foregroundColor(TVTheme.focus)
        Spacer(minLength: 0)
        Image(systemName: done ? "checkmark.circle.fill" : routine.systemImage)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      Text(routine.title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)
        .lineLimit(2)

      Text(routine.subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(2)

      Spacer(minLength: 0)

      Text(routineLine(routine, done: done))
      .font(TVTypography.detail)
      .foregroundColor(TVTheme.textMuted)
    }
    .frame(width: 350, height: 220, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: done)
    .tvFocusableCard()
  }

  /// What the card says of the day: done, left part way, or not yet begun.
  private func routineLine(_ routine: TVDhikrRoutine, done: Bool) -> String {
    if done {
      return tvLocalized("Done today")
    }
    if let said = viewModel.remembrancesSaidToday(of: routine) {
      return tvLocalized("%d of %d remembrances", said, routine.totalCount)
    }
    if routine.isPhrase {
      return tvLocalized("%d times", routine.totalCount)
    }
    return tvLocalized("%d remembrances · about %d min", routine.totalCount, routine.estimatedMinutes)
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .dhikr, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .dhikr)
    }
  }
}
