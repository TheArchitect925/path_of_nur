import SwiftUI

struct TVLearnScreen: View {
  @ObservedObject var viewModel: TVLearnViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @FocusState private var focusedSection: String?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
        TVHeroCard(
          eyebrow: tvLocalized("Learn"),
          title: tvLocalized("Learn"),
          subtitle: viewModel.hero.subtitle,
          supportingLine: viewModel.hero.supportingLine
        )

        TVSectionHeader(
          title: viewModel.primarySectionTitle,
          subtitle: viewModel.primarySectionSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          Group {
            if viewModel.primaryItems.isEmpty {
              emptyShelfCard(emphasized: true)
            } else {
              LazyHStack(spacing: TVTheme.railSpacing) {
                ForEach(Array(viewModel.primaryItems.enumerated()), id: \.element.id) { index, item in
                  let focusID = index == 0
                      ? TVFocusSectionId.learnPrimary
                      : "learn.primary.\(item.id)"

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

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          LazyVStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
            ForEach(viewModel.sections) { section in
              VStack(alignment: .leading, spacing: 16) {
                TVSectionHeader(
                  title: section.title,
                  subtitle: section.subtitle
                )

                ScrollView(.horizontal, showsIndicators: false) {
                  Group {
                    if section.items.isEmpty {
                      emptyShelfCard()
                    } else {
                      LazyHStack(spacing: TVTheme.railSpacing) {
                        ForEach(section.items) { item in
                          let focusID = "learn.section.\(section.id).\(item.id)"
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
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          _detailRail
            .frame(width: 420, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.storiesSectionTitle,
          subtitle: viewModel.storiesSectionSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            Text(viewModel.storiesSectionSupportingLine)
              .font(TVTypography.bodySecondary)
              .foregroundColor(TVTheme.textSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.activeStoryCollection.entries.isEmpty {
                  emptyShelfCard()
                } else {
                  LazyHStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.activeStoryCollection.entries.enumerated()), id: \.element.id) { index, entry in
                      let focusID = index == 0
                          ? TVFocusSectionId.learnStory
                          : "learn.story.\(entry.id)"

                      Button {
                        viewModel.selectStoryEntry(entry)
                      } label: {
                        TVLearnStoryEntryCard(
                          entry: entry,
                          isSelected: viewModel.selectedStoryEntry?.id == entry.id
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

          _storyRail
            .frame(width: 460, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.visualsSectionTitle,
          subtitle: viewModel.visualsSectionSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            Text(viewModel.visualsSectionSupportingLine)
              .font(TVTypography.bodySecondary)
              .foregroundColor(TVTheme.textSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.activeVisualCollection.entries.isEmpty {
                  emptyShelfCard()
                } else {
                  LazyHStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.activeVisualCollection.entries.enumerated()), id: \.element.id) { index, entry in
                      let focusID = index == 0
                          ? TVFocusSectionId.learnVisual
                          : "learn.visual.\(entry.id)"

                      Button {
                        viewModel.selectVisualEntry(entry)
                      } label: {
                        TVLearnVisualEntryCard(
                          entry: entry,
                          isSelected: viewModel.selectedVisualEntry?.id == entry.id
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

          _visualRail
            .frame(width: 460, alignment: .top)
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
      if section.hasPrefix("learn.primary") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.learnPrimary, for: .learn)
      } else if section.hasPrefix("learn.section.") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.learnShelf, for: .learn)
      } else if section.hasPrefix("learn.story") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.learnStory, for: .learn)
      } else if section.hasPrefix("learn.visual") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.learnVisual, for: .learn)
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
  }

  private var _detailRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let selectedItem = viewModel.selectedItem {
        Text(viewModel.detailPanelTitle)
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

        Text(viewModel.layoutNoteTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(viewModel.layoutNoteSubtitle)
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

  private var _storyRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let selectedStory = viewModel.selectedStoryEntry {
        Text(viewModel.storyDetailTitle)
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

        Text(viewModel.storyReflectionTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(selectedStory.reflectionPrompt)
          .font(TVTypography.body)
          .foregroundColor(TVTheme.textSecondary)
        Divider()
          .overlay(TVTheme.surfaceStroke)

        Text(viewModel.storyDirectionTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(viewModel.storyDirectionSubtitle)
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

  private var _visualRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let selectedVisual = viewModel.selectedVisualEntry {
        Text(viewModel.visualDetailTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(selectedVisual.title)
          .font(TVTypography.sectionTitle)
          .foregroundColor(TVTheme.accentStrong)

        Text(selectedVisual.subtitle)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)

        Text(selectedVisual.supportingLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)

        Text(selectedVisual.accentLabel)
          .font(TVTypography.chip)
          .foregroundColor(TVTheme.prayerNextText)
          .padding(.horizontal, 14)
          .padding(.vertical, 8)
          .background(
            Capsule(style: .continuous)
              .fill(TVTheme.prayerNext.opacity(0.85))
          )

        VStack(alignment: .leading, spacing: 12) {
          ForEach(selectedVisual.takeawayPoints, id: \.self) { point in
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

        Text(viewModel.visualReflectionTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(selectedVisual.observationPrompt)
          .font(TVTypography.body)
          .foregroundColor(TVTheme.textSecondary)
        Divider()
          .overlay(TVTheme.surfaceStroke)

        Text(viewModel.visualDirectionTitle)
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)

        Text(viewModel.visualDirectionSubtitle)
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

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .learn, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = appViewModel.preferredContentSection(for: .learn)
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
