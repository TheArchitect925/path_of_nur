import SwiftUI

struct TVQuranPlaybackCard: View {
  @ObservedObject var viewModel: TVQuranViewModel
  let primaryFocusID: String
  var focusedSection: FocusState<String?>.Binding

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 6) {
          Text(tvLocalized("Playback"))
            .font(TVTypography.summaryTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          Text(viewModel.playbackSummary)
            .font(TVTypography.sectionSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .tvReadableBody()
        }

        Spacer()

        Text(viewModel.selectedReciter.displayName)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()
      }

      HStack(spacing: 16) {
        ForEach(TVQuranReciter.allCases, id: \.self) { reciter in
          Button {
            viewModel.selectReciter(reciter)
          } label: {
            Text(reciter.shortLabel)
              .font(TVTypography.chip)
              .foregroundColor(
                viewModel.selectedReciter == reciter
                    ? TVTheme.prayerCurrentText
                    : TVTheme.textPrimary
              )
              .padding(.horizontal, 18)
              .padding(.vertical, 12)
              .background(
                viewModel.selectedReciter == reciter
                    ? TVTheme.prayerCurrent
                    : TVTheme.surfaceSoft,
                in: Capsule()
              )
          }
          .buttonStyle(.plain)
          .accessibilityLabel(tvLocalized("Switch reciter to %@.", reciter.displayName))
        }
      }

      HStack(spacing: 18) {
        _playbackButton(systemName: "backward.fill") {
          viewModel.playPreviousAyah()
        }

        _playbackButton(
          systemName: viewModel.isPlaying ? "pause.fill" : "play.fill",
          large: true,
          focusID: primaryFocusID,
          focusedSection: focusedSection
        ) {
          viewModel.togglePlayback()
        }

        _playbackButton(systemName: "forward.fill") {
          viewModel.playNextAyah()
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
        .padding(.vertical, 14)
        .background(TVTheme.surfaceSoft, in: Capsule())
      }
      .buttonStyle(.plain)
      .tvFocusableCard()
      .accessibilityLabel(tvLocalized("Open listening mode"))
      .accessibilityHint(tvLocalized("Opens full-screen listening controls."))

      if let errorMessage = viewModel.playbackErrorMessage {
        Text(errorMessage)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.cautionText)
          .tvReadableBody()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true)
  }

  private func _playbackButton(
    systemName: String,
    large: Bool = false,
    focusID: String? = nil,
    focusedSection: FocusState<String?>.Binding? = nil,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: large ? 32 : 24, weight: .bold))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: large ? 92 : 76, height: large ? 92 : 76)
        .background(
          RoundedRectangle(cornerRadius: 26, style: .continuous)
            .fill(large ? TVTheme.accentSoft : TVTheme.surfaceSoft)
        )
    }
    .buttonStyle(.plain)
    .tvFocusableCard()
    .accessibilityLabel(_playbackAccessibilityLabel(systemName: systemName))
    .modifier(
      TVPlaybackFocusModifier(
        focusID: focusID,
        focusedSection: focusedSection
      )
    )
  }

  private func _playbackAccessibilityLabel(systemName: String) -> String {
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

private struct TVPlaybackFocusModifier: ViewModifier {
  let focusID: String?
  let focusedSection: FocusState<String?>.Binding?

  func body(content: Content) -> some View {
    if let focusID, let focusedSection {
      content
        .focused(focusedSection, equals: focusID)
    } else {
      content
    }
  }
}
