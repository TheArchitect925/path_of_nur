import SwiftUI

struct TVHomeScreen: View {
    @ObservedObject var viewModel: TVHomeViewModel
    @EnvironmentObject private var appViewModel: TVAppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
                TVHeroBanner(
                    title: viewModel.greeting,
                    subtitle: viewModel.subtitle,
                    eyebrow: "\(viewModel.dateLabel) • \(viewModel.hijriLabel)",
                    supportingLine: "\(viewModel.currentPrayer) is active • \(viewModel.nextPrayer)"
                )

                TVSectionHeader(
                    title: "Quick Access",
                    subtitle: "Immediate paths for prayer, learning, remembrance, and listening."
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: TVTheme.railSpacing) {
                        ForEach(viewModel.quickLinks) { link in
                            Button {
                                appViewModel.selectedTab = link.destinationTab
                            } label: {
                                TVQuickLinkTile(link: link)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }

                ForEach(viewModel.shelves) { shelf in
                    TVContentShelfRow(section: shelf) { item in
                        TVDetailTemplate(item: item) {
                            EmptyView()
                        }
                    }
                }
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle("Home")
    }
}
