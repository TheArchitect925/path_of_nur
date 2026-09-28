import SwiftUI

struct TVGamesScreen: View {
  @ObservedObject var viewModel: TVGamesViewModel
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
                if viewModel.primaryItems.isEmpty {
                  emptyShelfCard(emphasized: true)
                } else {
                  HStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.primaryItems.enumerated()), id: \.element.id) { index, item in
                      let focusID = index == 0
                          ? TVFocusSectionId.gamesPrimary
                          : "games.primary.\(item.id)"

                      Button {
                        viewModel.selectPrimaryItem(item)
                      } label: {
                        TVLearnHubItemCard(
                          item: item,
                          isSelected: viewModel.selectedPrimaryItem?.id == item.id
                        )
                      }
                      .buttonStyle(TVCardButtonStyle())
                      .focused($focusedSection, equals: focusID)
                    }
                  }
                }
              }
              .padding(TVTheme.railBleed)
            }
            .tvRail()
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          detailRail
            .frame(width: 440, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.challengeTitle,
          subtitle: viewModel.challengeSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.challengeCards.isEmpty {
                  emptyShelfCard()
                } else {
                  HStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.challengeCards.enumerated()), id: \.element.id) { index, item in
                      let focusID = index == 0
                          ? TVFocusSectionId.gamesChallenge
                          : "games.challenge.\(item.id)"

                      Button {
                        viewModel.selectChallenge(item)
                      } label: {
                        TVGamesChallengeCardView(
                          item: item,
                          isSelected: viewModel.selectedChallenge?.id == item.id
                        )
                      }
                      .buttonStyle(TVCardButtonStyle())
                      .focused($focusedSection, equals: focusID)
                    }
                  }
                }
              }
              .padding(TVTheme.railBleed)
            }
            .tvRail()
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          challengeRail
            .frame(width: 500, alignment: .top)
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
      if section.hasPrefix("games.primary") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.gamesPrimary, for: .games)
      } else if section.hasPrefix("games.challenge") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.gamesChallenge, for: .games)
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
  }

  private var detailRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let selectedItem = viewModel.selectedPrimaryItem {
        Text(viewModel.detailRailTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(selectedItem.title)
          .font(TVTypography.sectionTitle)
          .foregroundColor(TVTheme.accentStrong)

        Text(selectedItem.subtitle)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)

        Text(selectedItem.supportingLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)
      } else {
        emptyRailCard()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: true)
  }

  private var challengeRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let challenge = viewModel.selectedChallenge {
        Text(viewModel.challengeRailTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(challenge.title)
          .font(TVTypography.sectionTitle)
          .foregroundColor(TVTheme.accentStrong)

        Text(challenge.prompt)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(challenge.promptSupport)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)

        Text(viewModel.challengeAnswerTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        VStack(alignment: .leading, spacing: 14) {
          ForEach(challenge.options) { option in
            Button {
              viewModel.selectOption(option)
            } label: {
              VStack(alignment: .leading, spacing: 6) {
                Text(option.title)
                  .font(TVTypography.summaryLine)
                  .foregroundColor(TVTheme.textPrimary)

                Text(option.supportingLine)
                  .font(TVTypography.detail)
                  .foregroundColor(TVTheme.textSecondary)
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(18)
              .background(
                RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
                  .fill(
                    viewModel.selectedOption?.id == option.id
                        ? TVTheme.surfaceElevated
                        : TVTheme.surfaceSoft.opacity(0.84)
                  )
                  .overlay(
                    RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
                      .stroke(
                        viewModel.selectedOption?.id == option.id
                            ? TVTheme.focus.opacity(0.55)
                            : TVTheme.surfaceStroke,
                        lineWidth: 1
                      )
                  )
              )
            }
            .buttonStyle(TVCardButtonStyle())
          }
        }

        if let selectedOption = viewModel.selectedOption {
          Divider()
            .overlay(TVTheme.surfaceStroke)

          Text(viewModel.challengeFeedbackTitle)
            .font(TVTypography.summaryTitle)
            .foregroundColor(TVTheme.textPrimary)

          Text(selectedOption.feedbackTitle)
            .font(TVTypography.sectionSubtitle)
            .foregroundColor(selectedOption.isCorrect ? TVTheme.focus : TVTheme.textPrimary)

          Text(selectedOption.feedbackBody)
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.textSecondary)
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
    guard appViewModel.selectedRoute == .games, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .games)
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
