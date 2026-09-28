import SwiftUI

/// The Qur'an in two panes: the 114 surahs on one side, the surah being read
/// on the other. Each pane scrolls by itself and neither is taller than the
/// screen, so a viewer deep in one still finds the other beside them.
struct TVQuranScreen: View {
  @ObservedObject var viewModel: TVQuranViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @EnvironmentObject private var themeController: TVThemeController
  @Environment(\.layoutDirection) private var layoutDirection
  @FocusState private var focusedSection: String?

  @State private var planner = TVQuranAyahPlanner()
  @State private var listScrollRequest = ScrollRequest()
  @State private var readerScrollRequest = ScrollRequest()
  @State private var focusSeeker = TVFocusSeeker()
  @State private var lastFocusedSection: String?
  /// The ayah the reader last followed the recitation to.
  @State private var followedAyahID: String?
  /// Where the viewer last was in the reader, to come back to.
  @State private var placeInReader: String?
  @State private var isOptionsPresented = false
  @State private var isGoToPresented = false

  /// A pane asked to bring what is selected into view.
  private struct ScrollRequest: Equatable {
    var count = 0
    var isAnimated = false

    mutating func ask(animated: Bool) {
      count += 1
      isAnimated = animated
    }
  }

  private static let listWidth: CGFloat = 420
  /// Between one ayah and the next.
  private static let ayahSpacing: CGFloat = 16
  /// Above each ayah, inside its row: the pane's margin, and a little more
  /// for the tallest card, which grows the most when it takes the focus.
  private static let ayahLead = TVTheme.railBleed + 6
  /// Between a pane and its heading: the room the pane's edge fades in.
  private static let paneSpacing = TVTheme.railFeather
  /// What a pane keeps clear inside its own edges for the focused card to
  /// grow into, past where the fading stops.
  private static let paneInset = TVTheme.railBleed - TVTheme.railFeather

  var body: some View {
    VStack(alignment: .leading, spacing: TVTheme.blockSpacing) {
      TVCompactHeroCard(
        title: tvLocalized("Qur’an"),
        subtitle: tvLocalized("Read and listen")
      ) {
        TVQuranListenBar(
          viewModel: viewModel,
          focusedSection: $focusedSection,
          onLeaveTowardRail: { appViewModel.focusNavigation() },
          onOpenOptions: { isOptionsPresented = true }
        )
      }
      .focusSection()

      // As far apart as each reaches past its own edge, so that what fades
      // at the side of one pane does not fade across the cards of the other.
      HStack(alignment: .top, spacing: TVTheme.railBleed) {
        surahPane
          .frame(width: Self.listWidth)

        readerPane
          .frame(maxWidth: .infinity)
      }
      .frame(maxHeight: .infinity, alignment: .top)
    }
    .padding(.horizontal, TVTheme.outerPadding)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .onAppear {
      followedAyahID = viewModel.selectedAyah?.id
      viewModel.refreshVerseOfTheDay()
      restorePreferredFocus()
    }
    .fullScreenCover(isPresented: $viewModel.isListeningModePresented) {
      TVQuranListeningModeScreen(viewModel: viewModel)
        .environmentObject(themeController)
    }
    .fullScreenCover(isPresented: $isGoToPresented) {
      TVQuranGoToScreen(
        viewModel: viewModel,
        onChoose: { place in
          isGoToPresented = false
          // Once the cover is gone, so that the focus has the reader to go to.
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            open(surah: place.surahNumber, ayah: place.ayahNumber)
          }
        },
        onClose: { isGoToPresented = false }
      )
      .environmentObject(themeController)
    }
    .fullScreenCover(isPresented: $isOptionsPresented) {
      ZStack(alignment: .trailing) {
        TVCoverBackground()
        TVQuranPlayerOptionsPanel(viewModel: viewModel) {
          isOptionsPresented = false
        }
        .padding(.vertical, 30)
        .padding(.trailing, 44)
      }
      .environmentObject(themeController)
    }
    .onChange(of: appViewModel.contentFocusRequest) { _ in
      restorePreferredFocus()
    }
    .onChange(of: focusedSection) { section in
      let previous = lastFocusedSection
      lastFocusedSection = section
      // The list rests at the surah being read whenever the viewer is not
      // in it, so that surah is there to come back to.
      if previous?.hasPrefix(TVFocusSectionId.quranBrowse) == true,
         section?.hasPrefix(TVFocusSectionId.quranBrowse) != true,
         focusSeeker.pending == nil {
        listScrollRequest.ask(animated: true)
      }

      guard let section else { return }
      if section.hasPrefix(TVFocusSectionId.quranPlayback) {
        appViewModel.markContentSectionFocused(TVFocusSectionId.quranPlayback, for: .quran)
      } else if section.hasPrefix(TVFocusSectionId.quranBrowse) {
        appViewModel.markContentSectionFocused(TVFocusSectionId.quranBrowse, for: .quran)
      } else if section.hasPrefix(TVFocusSectionId.quranReader) {
        appViewModel.markContentSectionFocused(TVFocusSectionId.quranReader, for: .quran)
        placeInReader = section
        // Where the focus rests in the reader is where the viewer is.
        viewModel.keepPlace(
          ayahID: String(section.dropFirst(TVFocusSectionId.quranReader.count + 1))
        )
      }
    }
    .onChange(of: viewModel.selectedSurah.id) { _ in
      placeInReader = nil
      if focusedSection?.hasPrefix(TVFocusSectionId.quranBrowse) != true {
        listScrollRequest.ask(animated: true)
      }
      syncFocusedTargetIfNeeded()
    }
    .onChange(of: viewModel.selectedAyah?.id) { ayahID in
      let previous = followedAyahID
      followedAyahID = ayahID
      // The reader follows the recitation only while the focus rests on the
      // ayah being recited. A viewer who has read ahead is left where they are.
      if let previous, isFocused(onAyah: previous) {
        syncFocusedTargetIfNeeded()
      }
    }
    .onPlayPauseCommand {
      if let index = focusedAyahIndex {
        viewModel.playOrPauseAyah(at: index)
      } else {
        viewModel.togglePlayback()
      }
    }
  }

  // MARK: - The list of surahs

  private var surahPane: some View {
    VStack(alignment: .leading, spacing: Self.paneSpacing) {
      TVSectionHeader(
        title: tvLocalized("Surahs"),
        subtitle: ""
      )

      if viewModel.surahs.isEmpty {
        emptyCard(tvLocalized("No surahs here yet."))
      } else {
        ScrollViewReader { proxy in
          ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 12) {
              shortcutRail

              ForEach(viewModel.surahs) { surah in
                surahButton(surah)
              }
            }
            .padding(TVTheme.railBleed)
          }
          .onAppear {
            proxy.scrollTo(viewModel.selectedSurah.id, anchor: .center)
          }
          .onChange(of: listScrollRequest) { request in
            if request.isAnimated {
              withAnimation(.easeInOut(duration: 0.25)) {
                proxy.scrollTo(viewModel.selectedSurah.id, anchor: .center)
              }
            } else {
              proxy.scrollTo(viewModel.selectedSurah.id, anchor: .center)
            }
          }
        }
        .tvPane()
      }
    }
    .focusSection()
    .tvPreferredFocus($focusedSection, TVFocusSectionId.quranSurahRow(viewModel.selectedSurah.id))
  }

  /// Ways into the list. A short rail, so not a lazy one: a lazy row takes
  /// all the height it is offered.
  private var shortcutRail: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: TVTheme.railSpacing) {
        Button {
          // Taken before the reader is entered: entering it moves the
          // viewer's place.
          let place = viewModel.continueReadingPlace
          open(surah: place.surahNumber, ayah: place.ayahNumber)
        } label: {
          TVQuranBrowseCollectionCard(
            title: viewModel.continueReadingSummaryTitle,
            subtitle: viewModel.continueReadingLine,
            systemImage: "bookmark.fill"
          )
        }
        .buttonStyle(TVCardButtonStyle())
        .tvFocusID($focusedSection, TVFocusSectionId.quranContinueReading)
        .onMoveCommand { direction in
          if direction == .towardRail(in: layoutDirection) {
            appViewModel.focusNavigation()
          }
        }

        Button {
          open(
            surah: viewModel.dailyVerse.surahNumber,
            ayah: viewModel.dailyVerse.ayahNumber
          )
        } label: {
          TVQuranBrowseCollectionCard(
            title: viewModel.dailyVerseSummaryTitle,
            subtitle: viewModel.dailyVerse.locationLabel,
            systemImage: "sun.max.fill"
          )
        }
        .buttonStyle(TVCardButtonStyle())
        .tvFocusID($focusedSection, TVFocusSectionId.quranTodaysVerse)

        Button {
          isGoToPresented = true
        } label: {
          TVQuranBrowseCollectionCard(
            title: tvLocalized("Go to"),
            subtitle: viewModel.bookmarks.isEmpty
              ? tvLocalized("Juz, or an ayah by number")
              : tvLocalized("Bookmarks, juz, or an ayah"),
            systemImage: "arrow.turn.down.right"
          )
        }
        .buttonStyle(TVCardButtonStyle())
        .tvFocusID($focusedSection, TVFocusSectionId.quranGoTo)

        ForEach(viewModel.browseCollections) { collection in
          Button {
            viewModel.selectBrowseCollection(collection)
            focusList()
          } label: {
            TVQuranBrowseCollectionCard(
              collection: collection,
              isSelected: viewModel.collectionContainsSelectedSurah(collection)
            )
          }
          .buttonStyle(TVCardButtonStyle())
          .tvFocusID($focusedSection, TVFocusSectionId.quranCollection(collection.id))
        }
      }
      .padding(TVTheme.railBleed)
    }
    .tvRail()
  }

  private func surahButton(_ surah: TVQuranSurah) -> some View {
    Button {
      open(surah)
    } label: {
      TVQuranSurahRow(
        surah: surah,
        isSelected: surah.id == viewModel.selectedSurah.id
      )
    }
    .buttonStyle(TVCardButtonStyle())
    .tvFocusID($focusedSection, TVFocusSectionId.quranSurahRow(surah.id))
    .onMoveCommand { direction in
      if direction == .towardRail(in: layoutDirection) {
        appViewModel.focusNavigation()
      }
    }
  }

  // MARK: - The reader

  private var readerPane: some View {
    VStack(alignment: .leading, spacing: Self.paneSpacing) {
      HStack(alignment: .center, spacing: 16) {
        VStack(alignment: .leading, spacing: 6) {
          TVSectionHeader(
            title: tvLocalized("Reader"),
            subtitle: viewModel.readerSubtitle
          )

          if let errorMessage = viewModel.playbackErrorMessage {
            Text(errorMessage)
              .font(TVTypography.detail)
              .foregroundColor(TVTheme.cautionText)
              .lineLimit(2)
          }
        }

        Spacer(minLength: 12)

        TVQuranTransport(
          viewModel: viewModel,
          focusedSection: $focusedSection,
          onLeaveTowardRail: { focusList() }
        )
      }

      if viewModel.selectedAyahs.isEmpty {
        emptyCard(tvLocalized("No ayahs here yet."))
      } else {
        GeometryReader { geometry in
          ayahList(metrics: readerMetrics(in: geometry.size))
            .tvPane()
        }
      }
    }
    .focusSection()
    .tvPreferredFocus($focusedSection, placeInReader ?? selectedAyahFocusID)
    .onExitCommand {
      focusList()
    }
  }

  private func ayahList(metrics: TVQuranAyahMetrics) -> some View {
    ScrollViewReader { proxy in
      ScrollView(.vertical, showsIndicators: false) {
        // Each ayah carries the pane's own margin above it, inside its row,
        // and the rows close up by as much, so that ayahs stand as far apart
        // as before. A row brought to the top of the pane then has its card
        // clear of the fading edge, where it would otherwise stand under it:
        // the television finds such a card on the screen and leaves it there.
        LazyVStack(alignment: .leading, spacing: Self.ayahSpacing - Self.ayahLead) {
          ForEach(Array(viewModel.selectedAyahs.enumerated()), id: \.element.id) { index, ayah in
            ayahParts(ayah, at: index, metrics: metrics)
              .padding(.top, Self.ayahLead)
          }
        }
        .padding(.horizontal, TVTheme.railBleed)
        .padding(.bottom, TVTheme.railBleed)
      }
      // The ayahs are entered at the viewer's place from the controls above
      // them too, which are in the same pane. Said of the scroll view
      // itself: said of what is outside its feathered edge, it is not heard.
      .focusSection()
      .tvPreferredFocus($focusedSection, placeInReader ?? selectedAyahFocusID)
      .onAppear {
        // A surah opened at its first ayah is already where it should be.
        if viewModel.selectedAyahIndex > 0 {
          scrollReader(proxy, animated: false)
        }
      }
      .onChange(of: readerScrollRequest) { request in
        scrollReader(proxy, animated: request.isAnimated)
      }
    }
    // A new surah is a new page, begun at its top.
    .id(viewModel.selectedSurah.id)
  }

  /// The parts of one ayah, close together so they read as one.
  private func ayahParts(
    _ ayah: TVQuranAyah,
    at index: Int,
    metrics: TVQuranAyahMetrics
  ) -> some View {
    let isSelected = index == viewModel.selectedAyahIndex
    let isPlaying = viewModel.isPlaying && isSelected

    return VStack(spacing: 8) {
      ForEach(planner.parts(for: ayah, metrics: metrics)) { part in
        Button {
          viewModel.playOrPauseAyah(at: index)
        } label: {
          TVQuranAyahCard(
            part: part,
            isSelected: isSelected,
            isPlaying: isPlaying,
            metrics: metrics,
            isBookmarked: part.index == 0 && viewModel.isBookmarked(ayah)
          )
        }
        .buttonStyle(TVCardButtonStyle())
        .tvFocusID($focusedSection, TVFocusSectionId.quranAyahPart(part.id))
        .contextMenu {
          Button {
            viewModel.toggleBookmark(ayah)
          } label: {
            if viewModel.isBookmarked(ayah) {
              Label(tvLocalized("Remove bookmark"), systemImage: "bookmark.slash")
            } else {
              Label(tvLocalized("Bookmark this ayah"), systemImage: "bookmark")
            }
          }
        }
        .onMoveCommand { direction in
          if direction == .towardRail(in: layoutDirection) {
            focusList()
          }
        }
      }
    }
  }

  private func readerMetrics(in size: CGSize) -> TVQuranAyahMetrics {
    .reader(
      pane: size,
      inset: Self.paneInset,
      focusScale: TVTheme.focusScale,
      language: Locale.current.languageCode ?? "en"
    )
  }

  /// Brings the ayah in hand to the top of the pane. It is held by its top
  /// because that asks nothing of how tall it stands, which a list that
  /// draws its rows as they are wanted does not know of a row far off.
  private func scrollReader(_ proxy: ScrollViewProxy, animated: Bool) {
    guard let ayah = viewModel.selectedAyah else { return }
    if animated {
      withAnimation(.easeInOut(duration: 0.25)) {
        proxy.scrollTo(ayah.id, anchor: .top)
      }
    } else {
      proxy.scrollTo(ayah.id, anchor: .top)
    }
  }

  // MARK: - Opening a surah

  /// A surah chosen from the list opens in the reader, and the focus goes
  /// with it. One already open keeps the viewer's place in it.
  private func open(_ surah: TVQuranSurah) {
    if surah.id != viewModel.selectedSurah.id {
      viewModel.selectSurah(surah)
    }
    focusReader()
  }

  private func open(surah: Int, ayah: Int) {
    viewModel.select(surahNumber: surah, ayahNumber: ayah)
    focusReader()
  }

  // MARK: - Focus

  /// Into the reader, at the ayah that is selected.
  private func focusReader() {
    placeInReader = nil
    appViewModel.markContentSectionFocused(TVFocusSectionId.quranReader, for: .quran)
    moveFocus(to: TVFocusSectionId.quranReader)
  }

  /// Back to the list, at the surah being read.
  private func focusList() {
    appViewModel.markContentSectionFocused(TVFocusSectionId.quranBrowse, for: .quran)
    moveFocus(to: TVFocusSectionId.quranBrowse)
  }

  private func restorePreferredFocus() {
    guard appViewModel.selectedRoute == .quran, appViewModel.activeColumn == .content else {
      return
    }

    moveFocus(to: appViewModel.preferredContentSection(for: .quran))
    #if targetEnvironment(simulator)
    // TV_SAMPLE_FOCUS=quran.reader.2:282.p3 puts the focus on one control,
    // so a state can be looked at without a remote to reach it.
    if let sample = ProcessInfo.processInfo.environment["TV_SAMPLE_FOCUS"] {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        focusSeeker.seek(sample, with: $focusedSection)
      }
    }
    #endif
  }

  private func syncFocusedTargetIfNeeded() {
    guard appViewModel.selectedRoute == .quran, appViewModel.activeColumn == .content else {
      return
    }

    // Only the reader follows what is selected. A surah or an ayah that
    // changes while the viewer is in the list leaves them in the list.
    guard appViewModel.preferredContentSection(for: .quran) == TVFocusSectionId.quranReader else {
      return
    }

    placeInReader = nil
    // The next ayah is a step away: the reader moves to it, it does not jump.
    moveFocus(to: TVFocusSectionId.quranReader, animated: true)
  }

  /// Brings the target on screen, then asks for the focus until it lands
  /// there (see `TVFocusSeeker`).
  private func moveFocus(to section: String, animated: Bool = false) {
    let target = focusTarget(for: section)
    // The viewer's own place is where the reader already stands.
    let staysInPlace = section == TVFocusSectionId.quranReader && placeInReader != nil
    var isFirst = true

    focusSeeker.seek(target, with: $focusedSection) {
      defer { isFirst = false }
      switch section {
      case TVFocusSectionId.quranBrowse:
        listScrollRequest.ask(animated: animated && isFirst)
      case TVFocusSectionId.quranReader where !staysInPlace:
        readerScrollRequest.ask(animated: animated && isFirst)
      default:
        break
      }
    }
  }

  private func focusTarget(for section: String) -> String {
    switch section {
    case TVFocusSectionId.quranBrowse:
      if !viewModel.surahs.isEmpty {
        return TVFocusSectionId.quranSurahRow(viewModel.selectedSurah.id)
      }
      return TVFocusSectionId.quranPlayback
    case TVFocusSectionId.quranReader:
      return placeInReader ?? selectedAyahFocusID ?? TVFocusSectionId.quranPlayback
    default:
      return TVFocusSectionId.quranPlayback
    }
  }

  private var selectedAyahFocusID: String? {
    (viewModel.selectedAyah ?? viewModel.selectedAyahs.first).map {
      TVFocusSectionId.quranAyah($0.id)
    }
  }

  /// Whether the focus rests on any part of the ayah.
  private func isFocused(onAyah ayahID: String) -> Bool {
    guard let focusedSection else { return false }
    let first = TVFocusSectionId.quranAyah(ayahID)
    return focusedSection == first || focusedSection.hasPrefix("\(first).")
  }

  /// The ayah in focus, as its place in the surah.
  private var focusedAyahIndex: Int? {
    viewModel.selectedAyahs.firstIndex { isFocused(onAyah: $0.id) }
  }

  private func emptyCard(_ line: String) -> some View {
    TVEmptyStateCard(title: line, subtitle: "", supportingLine: "")
      .padding(TVTheme.cardPadding)
      .tvSurfaceCard(elevated: true, emphasized: true)
  }
}
