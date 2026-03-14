import SwiftUI

struct TVAudioPlaybackCard: View {
    let item: TVAudioItem
    @State private var isPlaying = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: item.systemImage)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(TVTheme.focus)
                Spacer()
                Text(item.durationLabel)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(TVTheme.textSecondary)
            }
            Text(item.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(TVTheme.textPrimary)
            Text(item.subtitle)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(TVTheme.textSecondary)
            Text(item.detail)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(TVTheme.textTertiary)
                .lineLimit(3)
            HStack(spacing: 12) {
                Label(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill")
                Spacer()
                Label("Now Playing", systemImage: "speaker.wave.2.fill")
                    .foregroundStyle(TVTheme.textTertiary)
            }
            .font(.system(size: 17, weight: .semibold, design: .rounded))
        }
        .frame(width: 420, height: 260, alignment: .topLeading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
                .fill(TVTheme.surface)
        )
        .onTapGesture {
            isPlaying.toggle()
        }
        .tvFocusableCard()
    }
}
