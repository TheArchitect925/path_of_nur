import SwiftUI

struct TVDetailTemplate<RelatedContent: View>: View {
    let item: TVShelfItem
    let relatedContent: RelatedContent

    init(item: TVShelfItem, @ViewBuilder relatedContent: () -> RelatedContent) {
        self.item = item
        self.relatedContent = relatedContent()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                TVHeroBanner(
                    title: item.title,
                    subtitle: item.subtitle,
                    eyebrow: item.eyebrow,
                    supportingLine: item.reference ?? "Path of Nūr tvOS companion"
                )

                VStack(alignment: .leading, spacing: 16) {
                    if let reference = item.reference {
                        Text(reference)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(TVTheme.focus)
                    }
                    Text(item.detailBody)
                        .font(.system(size: 24, weight: .regular, design: .rounded))
                        .foregroundStyle(TVTheme.textPrimary)
                        .lineSpacing(8)
                    Text("This tvOS template is designed for readable, sectioned learning on a large screen. Audio, resume state, and richer shared content sources can connect here later without changing the navigation model.")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .foregroundStyle(TVTheme.textSecondary)
                        .lineSpacing(7)
                }

                relatedContent
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle(item.title)
    }
}
