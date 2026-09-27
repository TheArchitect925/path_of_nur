import SwiftUI

/// One ayah, full screen, while it is recited. The controls keep to a single
/// row so the ayah has the height, and the ayah is set as large as that
/// height allows.
struct TVQuranListeningModeScreen: View {
  @ObservedObject var viewModel: TVQuranViewModel
  @Environment(\.dismiss) private var dismiss
  @FocusState private var focusedControl: String?
  @State private var focusSeeker = TVFocusSeeker()

  private static let playPauseID = "listening.playPause"
  private static let partPrefix = "listening.part."

  var body: some View {
    ZStack {
      // The same sky as the page beneath, and nothing of the page itself: a
      // cover drawn in the card colours is see-through, because they are.
      TVCoverBackground()

      VStack(spacing: TVTheme.railFeather) {
        _header

        GeometryReader { geometry in
          _ayahStage(in: geometry.size)
        }

        _controls
      }
      .padding(.horizontal, 72)
      .padding(.vertical, 42)
    }
    .onAppear {
      if !viewModel.isPlaying {
        viewModel.playSelectedAyah()
      }
      focusSeeker.seek(Self.playPauseID, with: $focusedControl)
    }
    .onChange(of: viewModel.selectedAyah?.id) { _ in
      // The part in focus went with its ayah; the focus goes back to the
      // control every ayah has.
      if focusedControl?.hasPrefix(Self.partPrefix) == true {
        focusSeeker.seek(Self.playPauseID, with: $focusedControl)
      }
    }
    .onPlayPauseCommand {
      viewModel.togglePlayback()
    }
  }

  private var _header: some View {
    HStack(alignment: .top, spacing: 20) {
      VStack(alignment: .leading, spacing: 10) {
        Text(tvLocalized("Listening mode"))
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)
          .tvReadableTitle()

        Text(viewModel.listeningModeHeaderLine)
          .font(TVTypography.sectionSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()

        if let errorMessage = viewModel.playbackErrorMessage {
          Text(errorMessage)
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.cautionText)
            .tvReadableBody()
        } else {
          Text(viewModel.listeningModeStatusLine)
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.accentStrong)
            .tvReadableBody()
        }
      }

      Spacer()

      Button {
        viewModel.closeListeningMode()
        dismiss()
      } label: {
        Label(
          tvLocalized("Close"),
          systemImage: "xmark.circle.fill"
        )
        .font(TVTypography.chip)
        .foregroundColor(TVTheme.textPrimary)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(TVTheme.surfaceSoft, in: Capsule())
      }
      .buttonStyle(TVCardButtonStyle(shape: .capsule))
      .tvFocusID($focusedControl, "listening.exit")
      .accessibilityLabel(tvLocalized("Close"))
    }
    // So that up from any control finds Close, not only from those under it.
    .focusSection()
  }

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
          .tvSurfaceCard(elevated: true, emphasized: true)
          .tvCombinedAccessibility(
            label: viewModel.listeningModeHeaderLine,
            hint: part.translation,
            value: viewModel.listeningModeStatusLine
          )
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
        .tvSurfaceCard(elevated: true, emphasized: true)
    }
  }

  private var _controls: some View {
    HStack(alignment: .center, spacing: 16) {
      HStack(spacing: 14) {
        _toggleChip(
          label: viewModel.repeatCurrentAyah
              ? tvLocalized("Repeat ayah on")
              : tvLocalized("Repeat ayah off"),
          focusID: "listening.repeat"
        ) {
          viewModel.toggleRepeatCurrentAyah()
        }

        _toggleChip(
          label: viewModel.showListeningTranslation
              ? tvLocalized("Translation on")
              : tvLocalized("Translation off"),
          focusID: "listening.translation"
        ) {
          viewModel.toggleListeningTranslation()
        }

        _toggleChip(
          label: viewModel.showListeningTransliteration
              ? tvLocalized("Transliteration on")
              : tvLocalized("Transliteration off"),
          focusID: "listening.transliteration"
        ) {
          viewModel.toggleListeningTransliteration()
        }
      }

      Spacer(minLength: 12)

      HStack(spacing: 18) {
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

      Spacer(minLength: 12)

      HStack(spacing: 14) {
        ForEach(TVQuranReciter.allCases, id: \.self) { reciter in
          let isChosen = viewModel.selectedReciter == reciter

          Button {
            viewModel.selectReciter(reciter)
          } label: {
            Text(reciter.shortLabel)
              .font(TVTypography.chip)
              .lineLimit(1)
              .foregroundColor(isChosen ? TVTheme.prayerCurrentText : TVTheme.textPrimary)
              .padding(.horizontal, 18)
              .padding(.vertical, 12)
              .background(
                isChosen ? TVTheme.prayerCurrent : TVTheme.surfaceSoft,
                in: Capsule()
              )
          }
          .buttonStyle(TVCardButtonStyle(shape: .capsule))
          .tvFocusID($focusedControl, "listening.reciter.\(reciter.rawValue)")
          .accessibilityLabel(tvLocalized("Switch reciter to %@.", reciter.displayName))
          .accessibilityValue(isChosen ? tvLocalized("Selected") : "")
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, TVTheme.cardPadding)
    .padding(.vertical, 18)
    .tvSurfaceCard(elevated: true)
    .focusSection()
    // Play and pause is what the row is entered at, from wherever above.
    .tvPreferredFocus($focusedControl, Self.playPauseID)
  }

  private func _toggleChip(
    label: String,
    focusID: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Text(label)
        .font(TVTypography.chip)
        .lineLimit(1)
        .foregroundColor(TVTheme.textPrimary)
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(TVTheme.surfaceSoft, in: Capsule())
    }
    .buttonStyle(TVCardButtonStyle(shape: .capsule))
    .tvFocusID($focusedControl, focusID)
    .accessibilityLabel(label)
  }

  private func _transportButton(
    systemName: String,
    large: Bool = false,
    focusID: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: large ? 30 : 22, weight: .bold))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: large ? 84 : 70, height: large ? 84 : 70)
        .background(
          RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(large ? TVTheme.accentSoft : TVTheme.surfaceSoft)
        )
    }
    .buttonStyle(TVCardButtonStyle(shape: .rounded(24)))
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
}
