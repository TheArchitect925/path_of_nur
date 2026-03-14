import SwiftUI

struct TVProgressScreen: View {
    @ObservedObject var viewModel: TVProgressViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
                TVSectionHeader(
                    title: "Progress",
                    subtitle: "A calm summary of prayer, learning, reflection, and drops without dense dashboards."
                )
                TVProgressSummaryCard(summary: viewModel.summary)
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle("Progress")
    }
}
