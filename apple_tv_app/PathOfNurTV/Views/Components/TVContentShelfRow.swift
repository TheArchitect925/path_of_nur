import SwiftUI

struct TVContentShelfRow<Destination: View>: View {
    let section: TVShelfSection
    let destinationBuilder: (TVShelfItem) -> Destination

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            TVSectionHeader(title: section.title, subtitle: section.subtitle)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: TVTheme.railSpacing) {
                    ForEach(section.items) { item in
                        NavigationLink {
                            destinationBuilder(item)
                        } label: {
                            TVFocusableContentCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
