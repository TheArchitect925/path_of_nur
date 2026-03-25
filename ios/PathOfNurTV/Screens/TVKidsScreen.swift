import SwiftUI

struct TVKidsScreen: View {
  @ObservedObject var viewModel: TVKidsViewModel
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
                          ? TVFocusSectionId.kidsPrimary
                          : "kids.primary.\(item.id)"

                      Button {
                        viewModel.selectItem(item)
                      } label: {
                        TVLearnHubItemCard(
                          item: item,
                          isSelected: viewModel.selectedItem?.id == item.id
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
            .frame(width: 440, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.featuredStoriesTitle,
          subtitle: viewModel.featuredStoriesSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.featuredStories.isEmpty {
                  emptyShelfCard()
                } else {
                  HStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.featuredStories.enumerated()), id: \.element.id) { index, story in
                      let focusID = index == 0
                          ? TVFocusSectionId.kidsStory
                          : "kids.story.\(story.id)"

                      Button {
                        viewModel.selectStory(story)
                      } label: {
                        TVLearnStoryEntryCard(
                          entry: story,
                          isSelected: viewModel.selectedStory?.id == story.id
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

          storyRail
            .frame(width: 460, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.supportTitle,
          subtitle: viewModel.supportSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.supportCards.enumerated()), id: \.element.id) { index, item in
              TVKidsSupportCardView(item: item)
                .focused(
                  $focusedSection,
                  equals: index == 0 ? TVFocusSectionId.kidsSupport : "kids.support.\(item.id)"
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
      if section.hasPrefix("kids.primary") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.kidsPrimary, for: .kids)
      } else if section.hasPrefix("kids.story") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.kidsStory, for: .kids)
      } else if section.hasPrefix("kids.support") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.kidsSupport, for: .kids)
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
  }

  private var detailRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let selectedItem = viewModel.selectedItem {
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

        VStack(alignment: .leading, spacing: 12) {
          ForEach(selectedItem.detailPoints, id: \.self) { point in
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

  private var storyRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let selectedStory = viewModel.selectedStory {
        Text(tvLocalized("Story focus"))
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(selectedStory.title)
          .font(TVTypography.sectionTitle)
          .foregroundColor(TVTheme.accentStrong)

        Text(selectedStory.subtitle)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)

        Text(selectedStory.supportingLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)

        VStack(alignment: .leading, spacing: 12) {
          ForEach(selectedStory.takeawayPoints, id: \.self) { point in
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

        Text(tvLocalized("Try together"))
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(selectedStory.reflectionPrompt)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textSecondary)
      } else {
        emptyRailCard()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: false)
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .kids, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .kids)
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
