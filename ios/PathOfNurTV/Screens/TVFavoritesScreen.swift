import SwiftUI

struct TVFavoritesScreen: View {
  @ObservedObject var viewModel: TVFavoritesViewModel
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
                          ? TVFocusSectionId.favoritesPrimary
                          : "favorites.primary.\(item.id)"

                      Button {
                        viewModel.selectPrimaryItem(item)
                      } label: {
                        TVLearnHubItemCard(
                          item: item,
                          isSelected: viewModel.selectedPrimaryItem?.id == item.id
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
          title: viewModel.savedItemsTitle,
          subtitle: viewModel.savedItemsSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.savedItems.isEmpty {
                  emptyShelfCard()
                } else {
                  HStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.savedItems.enumerated()), id: \.element.id) { index, item in
                      let focusID = index == 0
                          ? TVFocusSectionId.favoritesSaved
                          : "favorites.saved.\(item.id)"

                      Button {
                        viewModel.selectSavedItem(item)
                      } label: {
                        TVSavedItemCardView(
                          item: item,
                          isSelected: viewModel.selectedSavedItem?.id == item.id
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

          savedItemRail
            .frame(width: 500, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.supportTitle,
          subtitle: viewModel.supportSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.supportCards.enumerated()), id: \.element.id) { index, item in
              TVFavoritesSupportCardView(item: item)
                .focused(
                  $focusedSection,
                  equals: index == 0 ? TVFocusSectionId.favoritesSupport : "favorites.support.\(item.id)"
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
      if section.hasPrefix("favorites.primary") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.favoritesPrimary, for: .favorites)
      } else if section.hasPrefix("favorites.saved") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.favoritesSaved, for: .favorites)
      } else if section.hasPrefix("favorites.support") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.favoritesSupport, for: .favorites)
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

  private var savedItemRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let item = viewModel.selectedSavedItem {
        Text(viewModel.savedItemRailTitle)
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

        Text(viewModel.savedItemMetaTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        VStack(alignment: .leading, spacing: 12) {
          ForEach(item.tags, id: \.self) { tag in
            HStack(alignment: .top, spacing: 10) {
              Circle()
                .fill(TVTheme.focus)
                .frame(width: 8, height: 8)
                .padding(.top, 7)

              Text(tag)
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
    guard appViewModel.selectedRoute == .favorites, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .favorites)
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
