import SwiftUI

struct TVProphetsScreen: View {
    @ObservedObject var viewModel: TVProphetsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
                TVHeroBanner(
                    title: "Stories of the Prophets",
                    subtitle: "A flagship large-screen learning experience built for shared viewing and reflection.",
                    eyebrow: "Prophets",
                    supportingLine: "Story rails • timeline-inspired browsing • reverent presentation"
                )

                TVContentShelfRow(section: viewModel.shelf) { item in
                    TVProphetDetailScreen(item: item)
                }

                TVSectionHeader(
                    title: "Timeline & Geography",
                    subtitle: "Map-inspired and chronology-inspired browsing can connect here without overstating certainty."
                )

                HStack(spacing: TVTheme.railSpacing) {
                    TVFocusableContentCard(
                        item: TVShelfItem(
                            id: "timeline",
                            title: "Timeline Journey",
                            subtitle: "Browse prophetic eras gently",
                            eyebrow: "Prophets",
                            systemImage: "point.topleft.down.curvedto.point.bottomright.up",
                            detailBody: "A future timeline-focused pathway for tvOS prophets browsing.",
                            reference: nil
                        )
                    )
                    TVFocusableContentCard(
                        item: TVShelfItem(
                            id: "map",
                            title: "Map-Inspired View",
                            subtitle: "Regions, journeys, and context",
                            eyebrow: "Prophets",
                            systemImage: "globe.europe.africa.fill",
                            detailBody: "A symbolic geography entry point that stays honest about approximate tradition where needed.",
                            reference: nil
                        )
                    )
                }
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle("Prophets")
    }
}
