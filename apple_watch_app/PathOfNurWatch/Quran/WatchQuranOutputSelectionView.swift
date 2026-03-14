import SwiftUI

struct WatchQuranOutputSelectionView: View {
    let currentSource: WatchQuranPlaybackSourceType
    let availability: WatchAudioAvailabilitySnapshot
    let onSelectPhone: () -> Void
    let onSelectWatch: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Output")
                    .font(.headline)

                Button {
                    onSelectPhone()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phone / Device")
                        Text("Play from your phone or headphones.")
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.borderedProminent)
                .tint(currentSource == .phone ? WatchTheme.accent : .gray)

                Button {
                    onSelectWatch()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Watch")
                        Text(
                            availability.watchPlaybackAvailable
                                ? "Play downloaded audio on the watch."
                                : "Watch playback requires downloaded audio."
                        )
                        .font(.caption2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.borderedProminent)
                .tint(currentSource == .watch ? WatchTheme.accent : .gray)
                .disabled(!availability.watchPlaybackAvailable)
            }
            .padding()
        }
    }
}
