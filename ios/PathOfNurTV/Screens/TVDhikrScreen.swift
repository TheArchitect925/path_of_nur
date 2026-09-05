import SwiftUI

struct TVDhikrScreen: View {
  @ObservedObject var viewModel: TVDhikrViewModel
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
          title: viewModel.modesTitle,
          subtitle: viewModel.modesSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          Group {
            if viewModel.modes.isEmpty {
              emptyShelfCard(emphasized: true)
            } else {
              HStack(spacing: TVTheme.railSpacing) {
                ForEach(Array(viewModel.modes.enumerated()), id: \.element.id) { index, item in
                  Button {
                    viewModel.selectMode(item)
                  } label: {
                    TVDhikrModeCardView(item: item, isSelected: item.id == viewModel.selectedMode?.id)
                  }
                  .buttonStyle(.plain)
                    .focused(
                      $focusedSection,
                      equals: index == 0 ? TVFocusSectionId.dhikrModes : "dhikr.modes.\(item.id)"
                    )
                }
              }
            }
          }
          .padding(.vertical, 8)
        }

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
              .buttonStyle(.plain)
              .focused(
                $focusedSection,
                equals: index == 0 ? TVFocusSectionId.dhikrRoutines : "dhikr.routines.\(routine.id)"
              )
            }
          }
          .padding(.vertical, 8)
        }

        TVSectionHeader(
          title: viewModel.guidedFlowTitle,
          subtitle: viewModel.guidedFlowSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            if let selectedMode = viewModel.selectedMode {
              Text(selectedMode.title)
                .font(TVTypography.summaryTitle)
                .foregroundColor(TVTheme.textPrimary)

              Text(selectedMode.supportingLine)
                .font(TVTypography.featureSubtitle)
                .foregroundColor(TVTheme.textSecondary)

              if selectedPhrases.isEmpty {
                TVEmptyStateCard(
                  title: tvLocalized("Nothing ready yet"),
                  subtitle: tvLocalized("This shelf is not available on the current Apple TV build."),
                  supportingLine: tvLocalized("Keep exploring another section and return later.")
                )
              } else {
                HStack(spacing: 10) {
                  ForEach(selectedPhrases, id: \.self) { phrase in
                    phraseChip(phrase)
                  }
                }
              }
            } else {
              emptyRailCard()
            }
          }
          .frame(width: 420, alignment: .leading)
          .padding(TVTheme.cardPadding)
          .tvSurfaceCard(elevated: true, emphasized: true)

          VStack(alignment: .leading, spacing: 14) {
            Text(tvLocalized("Remembrance note"))
              .font(TVTypography.summaryTitle)
              .foregroundColor(TVTheme.textPrimary)

            Text(tvLocalized("Guided Dhikr on TV should keep phrases visible, pacing calm, and input minimal so remembrance stays central."))
              .font(TVTypography.detail)
              .foregroundColor(TVTheme.textSecondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(TVTheme.cardPadding)
          .tvSurfaceCard(elevated: true, emphasized: false)
        }

        ScrollView(.horizontal, showsIndicators: false) {
          Group {
            if viewModel.selectedModeSteps.isEmpty {
              emptyShelfCard()
            } else {
              HStack(spacing: TVTheme.railSpacing) {
                ForEach(Array(viewModel.selectedModeSteps.enumerated()), id: \.element.id) { index, step in
                  VStack(alignment: .leading, spacing: 16) {
                    Text(step.arabic)
                      .font(TVTypography.arabicBody)
                      .foregroundColor(TVTheme.textPrimary)

                    Text(step.transliteration)
                      .font(TVTypography.featureSubtitle)
                      .foregroundColor(TVTheme.textSecondary)

                    Text(step.translation)
                      .font(TVTypography.detail)
                      .foregroundColor(TVTheme.textPrimary)

                    Text(step.helperLine)
                      .font(TVTypography.caption)
                      .foregroundColor(TVTheme.textMuted)
                  }
                  .frame(width: 360, height: 240, alignment: .leading)
                  .padding(TVTheme.cardPadding)
                  .tvSurfaceCard(elevated: true, emphasized: index == 0)
                  .tvFocusableCard()
                  .focused(
                    $focusedSection,
                    equals: index == 0 ? TVFocusSectionId.dhikrGuidedFlow : "dhikr.guidedFlow.\(step.id)"
                  )
                }
              }
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
            ForEach(Array(viewModel.supportCards.enumerated()), id: \.element.id) { index, item in
              TVDhikrSupportCardView(item: item)
                .focused(
                  $focusedSection,
                  equals: index == 0 ? TVFocusSectionId.dhikrCompanion : "dhikr.companion.\(item.id)"
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
      if section.hasPrefix("dhikr.modes") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.dhikrModes, for: .dhikr)
      } else if section.hasPrefix("dhikr.routines") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.dhikrRoutines, for: .dhikr)
      } else if section.hasPrefix("dhikr.guidedFlow") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.dhikrGuidedFlow, for: .dhikr)
      } else if section.hasPrefix("dhikr.companion") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.dhikrCompanion, for: .dhikr)
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
    .fullScreenCover(isPresented: $viewModel.isRoutinePlayerPresented) {
      TVDhikrRoutinePlayerScreen(viewModel: viewModel)
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

      Text(
        done
          ? tvLocalized("Done today · play again")
          : tvLocalized("%d remembrances · about %d min", routine.totalCount, routine.estimatedMinutes)
      )
      .font(TVTypography.detail)
      .foregroundColor(TVTheme.textMuted)
    }
    .frame(width: 350, height: 220, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: done)
    .tvFocusableCard()
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .dhikr, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .dhikr)
    }
  }

  private var selectedPhrases: [String] {
    viewModel.selectedMode?.focusPhrases ?? []
  }

  @ViewBuilder
  private func phraseChip(_ phrase: String) -> some View {
    Text(phrase)
      .font(TVTypography.caption)
      .foregroundColor(TVTheme.textPrimary)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(TVTheme.surfaceSoft.opacity(0.8), in: Capsule())
  }

  private func emptyShelfCard(emphasized: Bool = false) -> some View {
    TVEmptyStateCard(
      title: tvLocalized("Nothing ready yet"),
      subtitle: tvLocalized("This shelf is not available on the current Apple TV build."),
      supportingLine: tvLocalized("Keep exploring another section and return later.")
    )
    .frame(width: 520, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: emphasized)
  }

  private func emptyRailCard() -> some View {
    TVEmptyStateCard(
      title: tvLocalized("Choose an item to preview"),
      subtitle: tvLocalized("Move focus across the available cards to load details here."),
      supportingLine: tvLocalized("If this shelf has no content on the current build, keep using the rest of the route and return later.")
    )
  }
}
