import SwiftUI

struct TVLearnScreen: View {
    @ObservedObject var viewModel: TVLearnViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
                TVSectionHeader(
                    title: "Learn",
                    subtitle: "Large, focused rails for Prophets, duʿā, Qur’an reflection, and family learning."
                )

                ForEach(viewModel.shelves) { shelf in
                    TVContentShelfRow(section: shelf) { item in
                        if shelf.id == "prophets" {
                            TVProphetDetailScreen(item: item)
                        } else {
                            TVDetailTemplate(item: item) {
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle("Learn")
    }
}
