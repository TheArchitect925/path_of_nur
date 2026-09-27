import SwiftUI

struct TVQuranScreen: View {
  @ObservedObject var viewModel: TVQuranViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @FocusState private var focusedSection: String?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
        TVHeroCard(
          eyebrow: "",
          title: tvLocalized("Qur’an"),
          subtitle: tvLocalized("Read and listen"),
          supportingLine: ""
        )

        ScrollView(.horizontal, showsIndicators: false) {
          Group {
            if hasSummaryContent {
              LazyHStack(spacing: TVTheme.railSpacing) {
                Button {
                  viewModel.selectSurah(
                    TVSeedRepository.quranSurahs.first(where: {
                      $0.number == viewModel.continueReading.surahNumber
                    }) ?? viewModel.selectedSurah
                  )
                } label: {
                  _summaryCard(
                    title: viewModel.continueReadingSummaryTitle,
                    line: viewModel.continueReadingLine
                  )
                }
                .buttonStyle(TVCardButtonStyle())

                Button {
                  viewModel.selectSurah(
                    TVSeedRepository.quranSurahs.first(where: {
                      $0.number == viewModel.dailyVerse.surahNumber
                    }) ?? viewModel.selectedSurah
                  )
                } label: {
                  _summaryCard(
                    title: viewModel.dailyVerseSummaryTitle,
                    line: viewModel.dailyVerse.locationLabel
                  )
                }
                .buttonStyle(TVCardButtonStyle())
              }
            } else {
              emptyShelfCard(emphasized: true)
            }
          }
          .padding(.vertical, 8)
          .padding(.horizontal, TVTheme.railBleed)
        }
        .padding(.horizontal, -TVTheme.railBleed)

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 16) {
            TVSectionHeader(
              title: tvLocalized("Surahs"),
              subtitle: ""
            )

            ScrollView(.horizontal, showsIndicators: false) {
              Group {
                if viewModel.browseCollections.isEmpty {
                  emptyShelfCard()
                } else {
                  LazyHStack(spacing: TVTheme.railSpacing) {
                    ForEach(Array(viewModel.browseCollections.enumerated()), id: \.element.id) { index, collection in
                      let focusID = index == 0
                          ? TVFocusSectionId.quranBrowse
                          : "quran.browse.collection.\(collection.id)"

                      Button {
                        viewModel.selectBrowseCollection(collection)
                      } label: {
                        TVQuranBrowseCollectionCard(
                          collection: collection,
                          isSelected: viewModel.collectionContainsSelectedSurah(collection)
                        )
                      }
                      .buttonStyle(TVCardButtonStyle())
                      .focused($focusedSection, equals: focusID)
                    }
                  }
                }
              }
              .padding(.vertical, 8)
              .padding(.horizontal, TVTheme.railBleed)
            }
            .padding(.horizontal, -TVTheme.railBleed)

            Group {
              if viewModel.surahs.isEmpty {
                emptyCard(tvLocalized("No surahs here yet."))
                  .padding(TVTheme.cardPadding)
                  .tvSurfaceCard(elevated: true, emphasized: false)
              } else {
                LazyVStack(spacing: 14) {
                  ForEach(viewModel.surahs) { surah in
                    let isSelected = surah.id == viewModel.selectedSurah.id
                    let focusID = TVFocusSectionId.quranSurahRow(surah.id)

                    Button {
                      viewModel.selectSurah(surah)
                    } label: {
                      TVQuranSurahRow(surah: surah, isSelected: isSelected)
                    }
                    .buttonStyle(TVCardButtonStyle())
                    .focused($focusedSection, equals: focusID)
                  }
                }
              }
            }
          }
          .frame(width: 540, alignment: .leading)

          VStack(alignment: .leading, spacing: 16) {
            TVSectionHeader(
              title: tvLocalized("Reader"),
              subtitle: viewModel.readerSubtitle
            )

            if viewModel.selectedAyahs.isEmpty {
              emptyCard(tvLocalized("No ayahs here yet."))
                .padding(TVTheme.cardPadding)
                .tvSurfaceCard(elevated: true, emphasized: true)
            } else {
              LazyVStack(spacing: 16) {
                ForEach(Array(viewModel.selectedAyahs.enumerated()), id: \.element.id) { index, ayah in
                  let isSelected = index == viewModel.selectedAyahIndex
                  let isPlaying = viewModel.isPlaying && isSelected
                  let focusID = TVFocusSectionId.quranAyah(ayah.id)

                  Button {
                    viewModel.selectAyah(at: index)
                  } label: {
                    TVQuranAyahCard(
                      ayah: ayah,
                      isSelected: isSelected,
                      isPlaying: isPlaying
                    )
                  }
                  .buttonStyle(TVCardButtonStyle())
                  .focused($focusedSection, equals: focusID)
                }
              }
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }

        TVSectionHeader(
          title: tvLocalized("Listen"),
          subtitle: ""
        )

        TVQuranPlaybackCard(
          viewModel: viewModel,
          primaryFocusID: TVFocusSectionId.quranPlayback,
          focusedSection: $focusedSection
        )
      }
      .padding(TVTheme.outerPadding)
    }
    .onAppear {
      restorePreferredFocus()
    }
    .fullScreenCover(isPresented: $viewModel.isListeningModePresented) {
      TVQuranListeningModeScreen(viewModel: viewModel)
    }
    .onChange(of: appViewModel.contentFocusRequest) { _ in
      restorePreferredFocus()
    }
    .onChange(of: focusedSection) { section in
      guard let section else { return }
      if section == TVFocusSectionId.quranPlayback {
        appViewModel.markContentSectionFocused(TVFocusSectionId.quranPlayback, for: .quran)
      } else if section == TVFocusSectionId.quranBrowse || section.hasPrefix("quran.browse.") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.quranBrowse, for: .quran)
      } else if section.hasPrefix("quran.reader.") {
        appViewModel.markContentSectionFocused(TVFocusSectionId.quranReader, for: .quran)
      }
    }
    .onChange(of: viewModel.selectedSurah.id) { _ in
      syncFocusedTargetIfNeeded()
    }
    .onChange(of: viewModel.selectedAyah?.id) { _ in
      syncFocusedTargetIfNeeded()
    }
    .onMoveCommand { direction in
      if direction == .left, appViewModel.preferredContentSection(for: .quran) != TVFocusSectionId.quranReader {
        appViewModel.focusNavigation()
      }
    }
  }

  private func _summaryCard(title: String, line: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(line)
        .font(TVTypography.summaryLine)
        .foregroundColor(TVTheme.accentStrong)
        .tvReadableBody()
    }
    .frame(width: 520, alignment: .leading)
    .padding(24)
    .tvSurfaceCard(elevated: true)
    .tvFocusableCard()
    .tvCombinedAccessibility(label: title, value: line)
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .quran, appViewModel.activeColumn == .content else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = focusTarget(for: appViewModel.preferredContentSection(for: .quran))
    }
  }

  private func syncFocusedTargetIfNeeded() {
    guard appViewModel.selectedRoute == .quran, appViewModel.activeColumn == .content else {
      return
    }

    let preferredSection = appViewModel.preferredContentSection(for: .quran)
    guard preferredSection == TVFocusSectionId.quranBrowse || preferredSection == TVFocusSectionId.quranReader else {
      return
    }

    DispatchQueue.main.async {
      focusedSection = focusTarget(for: preferredSection)
    }
  }

  private func focusTarget(for section: String) -> String {
    switch section {
    case TVFocusSectionId.quranBrowse:
      if !viewModel.browseCollections.isEmpty {
        return TVFocusSectionId.quranBrowse
      }
      if let firstSurah = viewModel.surahs.first {
        return TVFocusSectionId.quranSurahRow(firstSurah.id)
      }
      return TVFocusSectionId.quranPlayback
    case TVFocusSectionId.quranReader:
      if let ayah = viewModel.selectedAyah ?? viewModel.selectedAyahs.first {
        return TVFocusSectionId.quranAyah(ayah.id)
      }
      return TVFocusSectionId.quranPlayback
    default:
      return TVFocusSectionId.quranPlayback
    }
  }

  private var hasSummaryContent: Bool {
    !viewModel.continueReadingLine.isEmpty || !viewModel.dailyVerse.locationLabel.isEmpty
  }

  private func emptyShelfCard(emphasized: Bool = false) -> some View {
    emptyCard(tvLocalized("No surahs here yet."))
      .frame(width: 520, alignment: .leading)
      .padding(TVTheme.cardPadding)
      .tvSurfaceCard(elevated: true, emphasized: emphasized)
  }

  private func emptyCard(_ line: String) -> some View {
    TVEmptyStateCard(title: line, subtitle: "", supportingLine: "")
  }
}
