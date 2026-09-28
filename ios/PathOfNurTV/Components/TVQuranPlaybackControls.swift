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

/// The way into the player, and into what it is heard and read with.
struct TVQuranListenBar: View {
  @ObservedObject var viewModel: TVQuranViewModel
  var focusedSection: FocusState<String?>.Binding
  /// The viewer moved past the first control, toward the rail.
  var onLeaveTowardRail: () -> Void
  var onOpenOptions: () -> Void

  @Environment(\.layoutDirection) private var layoutDirection

  var body: some View {
    HStack(spacing: 14) {
      Button {
        viewModel.openListeningMode()
      } label: {
        Label(
          tvLocalized("Listen full screen"),
          systemImage: "play.rectangle.fill"
        )
        .font(TVTypography.figtreeMedium(22))
        .foregroundColor(TVTheme.prayerCurrentText)
        .padding(.horizontal, 22)
        .padding(.vertical, 12)
        .background(TVTheme.prayerCurrent, in: Capsule())
      }
      .buttonStyle(TVCardButtonStyle(shape: .capsule))
      .tvFocusID(focusedSection, TVFocusSectionId.quranPlaybackListening)
      .accessibilityLabel(tvLocalized("Listen full screen"))
      .accessibilityHint(tvLocalized("Opens the ayah full screen."))
      .onMoveCommand { direction in
        if direction == .towardRail(in: layoutDirection) {
          onLeaveTowardRail()
        }
      }

      Button {
        onOpenOptions()
      } label: {
        Label(
          optionsLine,
          systemImage: "slider.horizontal.3"
        )
        .font(TVTypography.figtreeMedium(22))
        .lineLimit(1)
        .foregroundColor(TVTheme.textPrimary)
        .padding(.horizontal, 22)
        .padding(.vertical, 12)
        .background(TVTheme.surfaceSoft, in: Capsule())
      }
      .buttonStyle(TVCardButtonStyle(shape: .capsule))
      .tvFocusID(focusedSection, TVFocusSectionId.quranPlaybackOptions)
      .accessibilityLabel(tvLocalized("Listening options"))
      .accessibilityValue(optionsLine)
    }
  }

  /// "Mishary Rashid Alafasy · English"
  private var optionsLine: String {
    let translation = viewModel.translation?.languageName ?? tvLocalized("No translation")
    return "\(viewModel.selectedReciter.name) · \(translation)"
  }
}
