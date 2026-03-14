import SwiftUI

struct TVProphetDetailScreen: View {
    let item: TVShelfItem

    var body: some View {
        TVDetailTemplate(item: item) {
            TVSectionHeader(
                title: "Related Lessons",
                subtitle: "Continue with connected prophets, themes, and Qur’anic references."
            )
        }
    }
}
