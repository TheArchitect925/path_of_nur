import SwiftUI

struct TVProfilesScreen: View {
  @ObservedObject var viewModel: TVProfilesViewModel
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
          title: viewModel.primaryTitle,
          subtitle: viewModel.primarySubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.profiles.isEmpty {
                  emptyShelfCard(emphasized: true)
                } else {
                  HStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.profiles.enumerated()), id: \.element.id) { index, profile in
                      let focusID = index == 0
                          ? TVFocusSectionId.profilesPrimary
                          : "profiles.primary.\(profile.id)"

                      Button {
                        appViewModel.selectHouseholdProfile(profile)
                      } label: {
                        TVHouseholdProfileCardView(
                          profile: profile,
                          isSelected: viewModel.selectedProfile?.id == profile.id,
                          isActive: viewModel.activeProfile?.id == profile.id
                        )
                      }
                      .buttonStyle(.plain)
                      .focused($focusedSection, equals: focusID)
                    }
                  }
                }
              }
              .padding(.vertical, 8)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          detailRail
            .frame(width: 460, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.continuityTitle,
          subtitle: viewModel.continuitySubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.continuityCards.isEmpty {
                  emptyShelfCard()
                } else {
                  HStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.continuityCards.enumerated()), id: \.element.id) { index, item in
                      let focusID = index == 0
                          ? TVFocusSectionId.profilesContinuity
                          : "profiles.continuity.\(item.id)"

                      Button {
                        viewModel.selectContinuityCard(item)
                      } label: {
                        TVSessionContinuityCardView(
                          item: item,
                          isSelected: viewModel.selectedContinuityCard?.id == item.id,
                          isActive: viewModel.activeProfile?.id == item.id
                        )
                      }
                      .buttonStyle(.plain)
                      .focused($focusedSection, equals: focusID)
                    }
                  }
                }
              }
              .padding(.vertical, 8)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          continuityRail
            .frame(width: 500, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.supportTitle,
          subtitle: viewModel.supportSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.supportCards.enumerated()), id: \.element.id) { index, item in
              TVHouseholdSupportCardView(item: item)
                .focused(
                  $focusedSection,
                  equals: index == 0 ? TVFocusSectionId.profilesSupport : "profiles.support.\(item.id)"
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
      if section.hasPrefix("profiles.primary") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.profilesPrimary, for: .profiles)
      } else if section.hasPrefix("profiles.continuity") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.profilesContinuity, for: .profiles)
      } else if section.hasPrefix("profiles.support") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.profilesSupport, for: .profiles)
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
  }

  private var detailRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let selectedProfile = viewModel.selectedProfile {
        Text(viewModel.detailRailTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        HStack(spacing: 14) {
          Text(selectedProfile.avatar)
            .font(.system(size: 38))

          VStack(alignment: .leading, spacing: 6) {
            Text(selectedProfile.title)
              .font(TVTypography.sectionTitle)
              .foregroundColor(TVTheme.accentStrong)

            Text(selectedProfile.subtitle)
              .font(TVTypography.featureSubtitle)
              .foregroundColor(TVTheme.textSecondary)
          }
        }

        Text(selectedProfile.supportingLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)

        VStack(alignment: .leading, spacing: 12) {
          ForEach(selectedProfile.detailPoints, id: \.self) { point in
            HStack(alignment: .top, spacing: 10) {
              Circle()
                .fill(TVTheme.focus)
                .frame(width: 8, height: 8)
                .padding(.top, 7)

              Text(point)
                .font(TVTypography.detail)
                .foregroundColor(TVTheme.textSecondary)
            }
          }
        }
        Divider()
          .overlay(TVTheme.surfaceStroke)

        Text(viewModel.detailRailNoteTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(viewModel.detailRailNoteSubtitle)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textSecondary)
      } else {
        emptyRailCard()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: true)
  }

  private var continuityRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let item = viewModel.selectedContinuityCard {
        Text(viewModel.continuityRailTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(item.title)
          .font(TVTypography.sectionTitle)
          .foregroundColor(TVTheme.accentStrong)

        Text(item.subtitle)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)

        Text(item.supportingLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)

        Text(item.detailLine)
          .font(TVTypography.summaryLine)
          .foregroundColor(TVTheme.textPrimary)

        Text(viewModel.continuityRailMetaTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        VStack(alignment: .leading, spacing: 12) {
          ForEach(item.chips, id: \.self) { chip in
            HStack(alignment: .top, spacing: 10) {
              Circle()
                .fill(TVTheme.focus)
                .frame(width: 8, height: 8)
                .padding(.top, 7)

              Text(chip)
                .font(TVTypography.detail)
                .foregroundColor(TVTheme.textSecondary)
            }
          }
        }
      } else {
        emptyRailCard()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: false)
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .profiles, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .profiles)
    }
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
