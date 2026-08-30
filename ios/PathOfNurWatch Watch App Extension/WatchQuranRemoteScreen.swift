import SwiftUI

/// Wrist control for recitation playing on the phone. The model owns the
/// transport (`sendQuranCommand`); this screen only reflects what came back.
struct WatchQuranRemoteScreen: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 10) {
          if let playback = model.quranPlayback {
            nowPlaying(playback)
            transport(playback)
          } else {
            idle
          }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
      }
      .navigationTitle(WatchStrings.quranRemoteTitle)
      .containerBackground(palette.backgroundGradient, for: .navigation)
    }
    .task {
      await model.refreshQuranPlayback()
    }
  }

  private func nowPlaying(_ playback: WatchQuranPlaybackPayload) -> some View {
    VStack(spacing: 4) {
      Text(statusLabel(playback))
        .font(WatchType.caption)
        .foregroundStyle(palette.accent)
      Text(playback.surahName)
        .font(WatchType.heroTitle)
        .foregroundStyle(palette.onSurface)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.8)
      if let ayah = playback.currentAyah {
        Text(WatchStrings.quranRemoteAyah(ayah))
          .font(WatchType.caption)
          .foregroundStyle(palette.onSurfaceSubtle)
      }
      Text(playback.reciterName)
        .font(WatchType.caption)
        .foregroundStyle(palette.onSurfaceMuted)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(palette.cardFillSoft)
    )
  }

  private func transport(_ playback: WatchQuranPlaybackPayload) -> some View {
    HStack(spacing: 8) {
      transportButton("gobackward.15", command: "seekBack15")
      transportButton(
        playback.isPlaying ? "pause.fill" : "play.fill",
        command: playback.isPlaying ? "pause" : "play",
        prominent: true
      )
      transportButton("goforward.15", command: "seekForward15")
    }
    .disabled(model.quranRemoteBusy)
    .opacity(model.quranRemoteBusy ? 0.6 : 1)
  }

  private func transportButton(
    _ systemImage: String,
    command: String,
    prominent: Bool = false
  ) -> some View {
    Button {
      Task { await model.sendQuranCommand(command) }
    } label: {
      Image(systemName: systemImage)
        .font(.system(size: prominent ? 20 : 16, weight: .semibold))
        .foregroundStyle(palette.accent)
        .frame(maxWidth: .infinity, minHeight: prominent ? 52 : 44)
        .background(
          RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(prominent ? palette.cardFill : palette.cardFillSoft)
        )
    }
    .buttonStyle(.plain)
  }

  private var idle: some View {
    VStack(spacing: 8) {
      Text(WatchStrings.quranRemoteIdleTitle)
        .font(WatchType.screenTitle)
        .foregroundStyle(palette.onSurface)
        .multilineTextAlignment(.center)

      if model.isPhoneReachableForSync {
        Button(WatchStrings.quranRemoteResumeLast) {
          Task { await model.sendQuranCommand("resumeLast") }
        }
        .foregroundStyle(palette.accent)
        .disabled(model.quranRemoteBusy)
      } else {
        Text(WatchStrings.quranRemoteUnreachableBody)
          .font(WatchType.caption)
          .foregroundStyle(palette.onSurfaceSubtle)
          .multilineTextAlignment(.center)
      }
    }
  }

  private func statusLabel(_ playback: WatchQuranPlaybackPayload) -> String {
    if playback.isBuffering { return WatchStrings.quranRemoteBuffering }
    return playback.isPlaying
      ? WatchStrings.quranRemoteNowPlaying
      : WatchStrings.quranRemotePaused
  }
}
