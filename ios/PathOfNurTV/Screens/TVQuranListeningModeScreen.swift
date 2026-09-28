import SwiftUI

/// The player: one ayah, full screen, while it is recited. The Arabic, its
/// reading and its meaning take the screen and are set as large as it
/// allows, so they can be read from across a room on a small television.
/// The controls keep to one slim bar at the bottom, which fades while the
/// recitation plays and comes back at a touch of the remote. Everything
/// else (repeat, what is shown, the translation, the reciter) is in the
/// options at the side.
struct TVQuranListeningModeScreen: View {
  @ObservedObject var viewModel: TVQuranViewModel
  @Environment(\.dismiss) private var dismiss
  @FocusState private var focusedControl: String?
  @State private var focusSeeker = TVFocusSeeker()
  /// The bar is faded back while nothing has been touched for a while.
  @State private var isBarResting = false
  @State private var restTimer: Timer?

  static let playPauseID = "listening.playPause"
  static let optionsID = "listening.options"
  static let repeatID = "listening.repeat"
  private static let partPrefix = "listening.part."
  private static let barHeight: CGFloat = 92
  /// How long the bar stays bright after the remote is last used.
  private static let restAfter: TimeInterval = 6

  var body: some View {
    ZStack(alignment: .trailing) {
      // The same sky as the page beneath, and nothing of the page itself: a
      // cover drawn in the card colours is see-through, because they are.
      TVCoverBackground()

      VStack(spacing: 18) {
        _header

        GeometryReader { geometry in
          _ayahStage(in: geometry.size)
        }

        _controls
      }
      .padding(.horizontal, 64)
      .padding(.top, 34)
      .padding(.bottom, 30)
      // While the options are open, they alone take the focus.
      .disabled(viewModel.isPlayerOptionsPresented)

      if viewModel.isPlayerOptionsPresented {
        Color.black.opacity(0.28)
          .ignoresSafeArea()
          .allowsHitTesting(false)

        TVQuranPlayerOptionsPanel(viewModel: viewModel) {
          closeOptions()
        }
        .padding(.vertical, 30)
        .padding(.trailing, 44)
        .transition(.move(edge: .trailing).combined(with: .opacity))
      }
    }
    .animation(.easeOut(duration: 0.22), value: viewModel.isPlayerOptionsPresented)
    .onAppear {
      if !viewModel.isPlaying {
        viewModel.playSelectedAyah()
      }
      viewModel.setScreenKeptAwake(true)
      focusSeeker.seek(Self.playPauseID, with: $focusedControl)
      wake()
    }
    .onDisappear {
      restTimer?.invalidate()
      viewModel.isPlayerOptionsPresented = false
      viewModel.setScreenKeptAwake(false)
    }
    .onChange(of: viewModel.selectedAyah?.id) { _ in
      // The part in focus went with its ayah; the focus goes back to the
      // control every ayah has.
      if focusedControl?.hasPrefix(Self.partPrefix) == true {
        focusSeeker.seek(Self.playPauseID, with: $focusedControl)
      }
    }
    .onChange(of: focusedControl) { _ in
      wake()
    }
    .onChange(of: viewModel.isPlaying) { _ in
      wake()
    }
    .onPlayPauseCommand {
      viewModel.togglePlayback()
      wake()
    }
    // Menu puts the options away first, and only then leaves the player.
    .onExitCommand {
      if viewModel.isPlayerOptionsPresented {
        closeOptions()
      } else {
        viewModel.closeListeningMode()
        dismiss()
      }
    }
  }

  // MARK: - The heading

  /// A single quiet line: where the recitation is, and who recites it.
  private var _header: some View {
    HStack(alignment: .firstTextBaseline, spacing: 20) {
      Text(viewModel.listeningModeHeaderLine)
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.textPrimary)
        .lineLimit(1)

      Text(viewModel.selectedSurah.arabicName)
        .font(TVTypography.amiriQuran(30))
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(1)

      Spacer(minLength: 20)

      if let errorMessage = viewModel.playbackErrorMessage {
        Text(errorMessage)
          .font(TVTypography.figtreeMedium(22))
          .foregroundColor(TVTheme.cautionText)
          .lineLimit(1)
      } else {
        // Read again every half minute, so a sleep timer counts down.
        TimelineView(.periodic(from: .now, by: 30)) { _ in
          Text(viewModel.listeningModeStatusLine)
            .font(TVTypography.figtreeMedium(22))
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(1)
        }
      }
    }
    .opacity(isBarResting ? 0.55 : 1)
    .animation(.easeInOut(duration: 0.6), value: isBarResting)
  }

  // MARK: - The ayah

  /// The ayah as the viewer has asked to see it.
  private var _shownAyah: TVQuranAyah? {
    guard let ayah = viewModel.selectedAyah else { return nil }
    return TVQuranAyah(
      id: ayah.id,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      arabic: ayah.arabic,
      transliteration: viewModel.showListeningTransliteration ? ayah.transliteration : "",
      translation: viewModel.showListeningTranslation ? ayah.translation : ""
    )
  }

  @ViewBuilder
  private func _ayahStage(in size: CGSize) -> some View {
    if let ayah = _shownAyah {
      let plan = TVQuranAyahPlanner.listeningPlan(
        for: ayah,
        stage: size,
        inset: TVTheme.railBleed - TVTheme.railFeather,
        focusScale: TVTheme.focusScale,
        language: Locale.current.languageCode ?? "en"
      )

      if plan.isWhole, let part = plan.parts.first {
        TVQuranAyahText(part: part, metrics: plan.metrics, isCentered: true)
          .padding(TVQuranAyahPlanner.listeningStagePadding)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(
            RoundedRectangle(cornerRadius: TVTheme.heroRadius, style: .continuous)
              .fill(TVTheme.surface)
          )
          .tvCombinedAccessibility(
            label: viewModel.listeningModeHeaderLine,
            hint: part.translation,
            value: viewModel.listeningModeStatusLine
          )
          .id(ayah.id)
          .transition(.opacity)
      } else {
        // Too long for the stage at any size: in parts, read by moving
        // through them.
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 12) {
            ForEach(plan.parts) { part in
              Button {
                viewModel.togglePlayback()
              } label: {
                // Every part here is of the ayah being recited, so none
                // is marked as playing: the only ring is the focus.
                TVQuranAyahCard(
                  part: part,
                  isSelected: false,
                  isPlaying: false,
                  metrics: plan.metrics,
                  isCentered: true
                )
              }
              .buttonStyle(TVCardButtonStyle())
              .tvFocusID($focusedControl, "\(Self.partPrefix)\(part.index)")
            }
          }
          .padding(TVTheme.railBleed)
        }
        .focusSection()
        // Read from its beginning, whichever part is nearest the controls.
        .tvPreferredFocus($focusedControl, "\(Self.partPrefix)0")
        .tvPane()
        .id(ayah.id)
      }
    } else {
      Text(tvLocalized("No ayah selected"))
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textSecondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  // MARK: - The bar

  private var _controls: some View {
    HStack(alignment: .center, spacing: 16) {
      // Where in the surah, and what it is waiting on.
      HStack(spacing: 12) {
        if viewModel.isBuffering {
          ProgressView()
            .scaleEffect(0.8)
        }
        Text(viewModel.ayahProgressLine)
          .font(TVTypography.figtreeMedium(24))
          .foregroundColor(TVTheme.textSecondary)
          .lineLimit(1)
      }
      .frame(minWidth: 260, alignment: .leading)

      Spacer(minLength: 12)

      _barChip(
        label: viewModel.repeatMode.shortTitle,
        systemImage: viewModel.repeatMode.systemImage,
        isOn: viewModel.repeatMode != .off,
        focusID: Self.repeatID
      ) {
        viewModel.cycleRepeat()
      }
      .accessibilityLabel(tvLocalized("Repeat"))
      .accessibilityValue(viewModel.repeatMode.title)

      HStack(spacing: 16) {
        _transportButton(
          systemName: "backward.fill",
          focusID: "listening.previous"
        ) {
          viewModel.playPreviousAyah()
        }

        _transportButton(
          systemName: viewModel.isPlaying ? "pause.fill" : "play.fill",
          large: true,
          focusID: Self.playPauseID
        ) {
          viewModel.togglePlayback()
        }

        _transportButton(
          systemName: "forward.fill",
          focusID: "listening.next"
        ) {
          viewModel.playNextAyah()
        }
      }
      // Drawn in playing order in every language.
      .environment(\.layoutDirection, .leftToRight)

      _barChip(
        label: tvLocalized("Options"),
        systemImage: "slider.horizontal.3",
        isOn: false,
        focusID: Self.optionsID
      ) {
        openOptions()
      }
      .accessibilityLabel(tvLocalized("Listening options"))
      .accessibilityHint(tvLocalized("Reciter, translation, transliteration and repeat."))

      if let ayah = viewModel.selectedAyah {
        let isBookmarked = viewModel.isBookmarked(ayah)
        Button {
          viewModel.toggleBookmark(ayah)
          wake()
        } label: {
          Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(isBookmarked ? TVTheme.accentStrong : TVTheme.textPrimary)
            .frame(width: 62, height: 62)
            .background(Circle().fill(TVTheme.surface))
        }
        .buttonStyle(TVCardButtonStyle(shape: .capsule))
        .tvFocusID($focusedControl, "listening.bookmark")
        .accessibilityLabel(isBookmarked ? tvLocalized("Remove bookmark") : tvLocalized("Bookmark this ayah"))
        .accessibilityValue(isBookmarked ? tvLocalized("Bookmarked") : "")
      }

      Spacer(minLength: 12)

      Text(viewModel.selectedReciter.name)
        .font(TVTypography.figtreeMedium(24))
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(1)
        .frame(minWidth: 260, alignment: .trailing)
    }
    .frame(height: Self.barHeight)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 28)
    .background(
      Capsule(style: .continuous)
        .fill(TVTheme.surfaceSoft)
    )
    .opacity(isBarResting ? 0.4 : 1)
    .animation(.easeInOut(duration: 0.6), value: isBarResting)
    .focusSection()
    // Play and pause is what the bar is entered at, from wherever above.
    .tvPreferredFocus($focusedControl, Self.playPauseID)
  }

  private func _barChip(
    label: String,
    systemImage: String,
    isOn: Bool,
    focusID: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Label(label, systemImage: systemImage)
        .font(TVTypography.figtreeMedium(24))
        .lineLimit(1)
        .foregroundColor(isOn ? TVTheme.prayerCurrentText : TVTheme.textPrimary)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
          isOn ? TVTheme.prayerCurrent : TVTheme.surface,
          in: Capsule()
        )
    }
    .buttonStyle(TVCardButtonStyle(shape: .capsule))
    .tvFocusID($focusedControl, focusID)
  }

  private func _transportButton(
    systemName: String,
    large: Bool = false,
    focusID: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: large ? 28 : 20, weight: .bold))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: large ? 76 : 62, height: large ? 76 : 62)
        .background(
          Circle()
            .fill(large ? TVTheme.accentSoft : TVTheme.surface)
        )
    }
    .buttonStyle(TVCardButtonStyle(shape: .capsule))
    .tvFocusID($focusedControl, focusID)
    .accessibilityLabel(_transportAccessibilityLabel(systemName: systemName))
  }

  private func _transportAccessibilityLabel(systemName: String) -> String {
    switch systemName {
    case "backward.fill":
      return tvLocalized("Previous ayah")
    case "forward.fill":
      return tvLocalized("Next ayah")
    default:
      return viewModel.isPlaying ? tvLocalized("Pause audio") : tvLocalized("Play audio")
    }
  }

  // MARK: - Options and rest

  private func openOptions() {
    viewModel.isPlayerOptionsPresented = true
    wake()
  }

  private func closeOptions() {
    viewModel.isPlayerOptionsPresented = false
    focusSeeker.seek(Self.optionsID, with: $focusedControl)
    wake()
  }

  /// The bar is bright again, and rests once more if nothing follows while
  /// the recitation plays.
  private func wake() {
    isBarResting = false
    restTimer?.invalidate()
    restTimer = Timer.scheduledTimer(withTimeInterval: Self.restAfter, repeats: false) { _ in
      DispatchQueue.main.async {
        if viewModel.isPlaying && !viewModel.isPlayerOptionsPresented {
          isBarResting = true
        }
      }
    }
  }
}
