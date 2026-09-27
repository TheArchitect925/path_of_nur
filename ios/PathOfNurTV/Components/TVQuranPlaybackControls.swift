import SwiftUI

extension MoveCommandDirection {
  /// The way back toward the rail: left, and right where the interface is
  /// turned for Arabic and Urdu.
  static func towardRail(in layoutDirection: LayoutDirection) -> MoveCommandDirection {
    layoutDirection == .rightToLeft ? .right : .left
  }
}

/// Previous, play or pause, next. The reader keeps these beside its heading,
/// so the ayahs have the height.
struct TVQuranTransport: View {
  @ObservedObject var viewModel: TVQuranViewModel
  var focusedSection: FocusState<String?>.Binding
  /// The viewer moved past the first control, toward the list of surahs.
  var onLeaveTowardRail: () -> Void

  @Environment(\.layoutDirection) private var layoutDirection

  var body: some View {
    HStack(spacing: 14) {
      control(
        systemName: "backward.fill",
        label: tvLocalized("Previous ayah"),
        focusID: TVFocusSectionId.quranPlaybackPrevious,
        isNearestRail: layoutDirection == .leftToRight
      ) {
        viewModel.playPreviousAyah()
      }

      control(
        systemName: viewModel.isPlaying ? "pause.fill" : "play.fill",
        label: viewModel.isPlaying ? tvLocalized("Pause audio") : tvLocalized("Play audio"),
        large: true,
        focusID: TVFocusSectionId.quranPlayback
      ) {
        viewModel.togglePlayback()
      }

      control(
        systemName: "forward.fill",
        label: tvLocalized("Next ayah"),
        focusID: TVFocusSectionId.quranPlaybackNext,
        isNearestRail: layoutDirection == .rightToLeft
      ) {
        viewModel.playNextAyah()
      }
    }
    // The controls are drawn in playing order in every language, so in a
    // turned interface it is the last of them that stands nearest the list.
    .environment(\.layoutDirection, .leftToRight)
  }

  private func control(
    systemName: String,
    label: String,
    large: Bool = false,
    focusID: String,
    isNearestRail: Bool = false,
    action: @escaping () -> Void
  ) -> some View {
    let towardRail = MoveCommandDirection.towardRail(in: layoutDirection)

    return Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: large ? 26 : 20, weight: .bold))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: large ? 68 : 58, height: large ? 68 : 58)
        .background(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(large ? TVTheme.accentSoft : TVTheme.surfaceSoft)
        )
    }
    .buttonStyle(TVCardButtonStyle(shape: .rounded(20)))
    .tvFocusID(focusedSection, focusID)
    .accessibilityLabel(label)
    .onMoveCommand { direction in
      if isNearestRail && direction == towardRail {
        onLeaveTowardRail()
      }
    }
  }
}

/// Who recites, and the way into listening mode.
struct TVQuranListenBar: View {
  @ObservedObject var viewModel: TVQuranViewModel
  var focusedSection: FocusState<String?>.Binding
  /// The viewer moved past the first control, toward the rail.
  var onLeaveTowardRail: () -> Void

  @Environment(\.layoutDirection) private var layoutDirection

  var body: some View {
    HStack(spacing: 14) {
      ForEach(Array(TVQuranReciter.allCases.enumerated()), id: \.element) { index, reciter in
        let isChosen = viewModel.selectedReciter == reciter

        Button {
          viewModel.selectReciter(reciter)
        } label: {
          Text(reciter.shortLabel)
            .font(TVTypography.chip)
            .foregroundColor(isChosen ? TVTheme.prayerCurrentText : TVTheme.textPrimary)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
              isChosen ? TVTheme.prayerCurrent : TVTheme.surfaceSoft,
              in: Capsule()
            )
        }
        .buttonStyle(TVCardButtonStyle(shape: .capsule))
        .tvFocusID(focusedSection, TVFocusSectionId.quranReciter(reciter.rawValue))
        .accessibilityLabel(tvLocalized("Switch reciter to %@.", reciter.displayName))
        .accessibilityValue(isChosen ? tvLocalized("Selected") : "")
        .onMoveCommand { direction in
          if index == 0 && direction == .towardRail(in: layoutDirection) {
            onLeaveTowardRail()
          }
        }
      }

      Button {
        viewModel.openListeningMode()
      } label: {
        Label(
          tvLocalized("Open listening mode"),
          systemImage: "speaker.wave.2.bubble.left.fill"
        )
        .font(TVTypography.chip)
        .foregroundColor(TVTheme.textPrimary)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(TVTheme.surfaceSoft, in: Capsule())
      }
      .buttonStyle(TVCardButtonStyle(shape: .capsule))
      .tvFocusID(focusedSection, TVFocusSectionId.quranPlaybackListening)
      .accessibilityLabel(tvLocalized("Open listening mode"))
      .accessibilityHint(tvLocalized("Opens the ayah full screen."))
    }
  }
}
