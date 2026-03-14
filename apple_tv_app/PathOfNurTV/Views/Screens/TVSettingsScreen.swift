import SwiftUI

struct TVSettingsScreen: View {
    @ObservedObject var viewModel: TVSettingsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
                TVSectionHeader(
                    title: "Settings",
                    subtitle: "TV-focused preferences for readability, audio, prayer display, and household use."
                )
                VStack(spacing: 16) {
                    ForEach(viewModel.options) { option in
                        TVSettingsRow(option: option)
                    }
                }
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle("Settings")
    }
}
