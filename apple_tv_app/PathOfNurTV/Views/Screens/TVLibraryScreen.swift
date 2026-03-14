import SwiftUI

struct TVLibraryScreen: View {
    @ObservedObject var viewModel: TVLibraryViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
                TVSectionHeader(
                    title: "Listen",
                    subtitle: "Qur’an recitation, duʿā audio, story playback, and ambient listening foundations."
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: TVTheme.railSpacing) {
                        ForEach(viewModel.items) { item in
                            TVAudioPlaybackCard(item: item)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle("Listen")
    }
}
