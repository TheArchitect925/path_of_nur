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
              .focused(
                $focusedSection,
                equals: index == 0 ? TVFocusSectionId.dhikrRoutines : "dhikr.routines.\(routine.id)"
              )
            }
          }
          .padding(.vertical, 8)
          .padding(.horizontal, TVTheme.railBleed)
        }
        .padding(.horizontal, -TVTheme.railBleed)

        TVSectionHeader(
          title: viewModel.modesTitle,
          subtitle: ""
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.modes.enumerated()), id: \.element.id) { index, item in
              Button {
                viewModel.selectMode(item)
              } label: {
                TVDhikrModeCardView(item: item, isSelected: item.id == viewModel.selectedMode?.id)
              }
              .buttonStyle(TVCardButtonStyle())
              .focused(
                $focusedSection,
                equals: index == 0 ? TVFocusSectionId.dhikrModes : "dhikr.modes.\(item.id)"
              )
            }
          }
          .padding(.vertical, 8)
          .padding(.horizontal, TVTheme.railBleed)
        }
        .padding(.horizontal, -TVTheme.railBleed)

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.selectedModeSteps.enumerated()), id: \.element.id) { index, step in
              VStack(alignment: .leading, spacing: 16) {
                Text(step.arabic)
                  .font(TVTypography.arabicBody)
                  .foregroundColor(TVTheme.textPrimary)
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .tvReadableArabic()

                Text(step.transliteration)
                  .font(TVTypography.featureSubtitle)
                  .foregroundColor(TVTheme.textSecondary)
                  .tvReadableBody()

                Text(step.translation)
                  .font(TVTypography.detail)
                  .foregroundColor(TVTheme.textPrimary)
                  .tvReadableBody()
              }
              .frame(width: 360, height: 200, alignment: .leading)
              .padding(TVTheme.cardPadding)
              .tvSurfaceCard(elevated: true, emphasized: index == 0)
              .tvFocusableCard()
              .focused(
                $focusedSection,
                equals: index == 0 ? TVFocusSectionId.dhikrGuidedFlow : "dhikr.guidedFlow.\(step.id)"
              )
              .tvCombinedAccessibility(label: step.transliteration, hint: step.translation)
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
      if section.hasPrefix("dhikr.modes") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.dhikrModes, for: .dhikr)
      } else if section.hasPrefix("dhikr.routines") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.dhikrRoutines, for: .dhikr)
      } else if section.hasPrefix("dhikr.guidedFlow") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.dhikrGuidedFlow, for: .dhikr)
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
          ? tvLocalized("Done today")
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
}
