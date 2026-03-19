import SwiftUI

struct TVQuranPlaybackCard: View {
  @ObservedObject var viewModel: TVQuranViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 6) {
          Text(NSLocalizedString("Playback", comment: ""))
            .font(.system(size: 34, weight: .bold, design: .serif))
            .foregroundStyle(TVTheme.textPrimary)

          Text(viewModel.playbackSummary)
            .font(.system(size: 19, weight: .medium, design: .rounded))
            .foregroundStyle(TVTheme.textSecondary)
        }

        Spacer()

        Text(viewModel.selectedReciter.displayName)
          .font(.system(size: 18, weight: .semibold, design: .rounded))
          .foregroundStyle(TVTheme.textSecondary)
      }

      HStack(spacing: 16) {
        ForEach(TVQuranReciter.allCases, id: \.self) { reciter in
          Button {
            viewModel.selectReciter(reciter)
          } label: {
            Text(reciter.shortLabel)
              .font(.system(size: 17, weight: .semibold, design: .rounded))
              .foregroundStyle(
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
        }
      }

      HStack(spacing: 18) {
        _playbackButton(systemName: "backward.fill") {
          viewModel.playPreviousAyah()
        }

        _playbackButton(
          systemName: viewModel.isPlaying ? "pause.fill" : "play.fill",
          large: true
        ) {
          viewModel.togglePlayback()
        }

        _playbackButton(systemName: "forward.fill") {
          viewModel.playNextAyah()
        }
      }

      if let errorMessage = viewModel.playbackErrorMessage {
        Text(errorMessage)
          .font(.system(size: 16, weight: .medium, design: .rounded))
          .foregroundStyle(TVTheme.cautionText)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(28)
    .background(
      RoundedRectangle(cornerRadius: 34, style: .continuous)
        .fill(TVTheme.surface)
    )
  }

  private func _playbackButton(
    systemName: String,
    large: Bool = false,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: large ? 32 : 24, weight: .bold))
        .foregroundStyle(TVTheme.textPrimary)
        .frame(width: large ? 92 : 76, height: large ? 92 : 76)
        .background(
          RoundedRectangle(cornerRadius: 26, style: .continuous)
            .fill(large ? TVTheme.accentSoft : TVTheme.surfaceSoft)
        )
    }
    .buttonStyle(.plain)
    .tvFocusableCard()
  }
}
