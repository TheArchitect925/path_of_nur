import SwiftUI

struct WatchStatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
            Text(value)
                .font(.headline)
                .foregroundStyle(WatchTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(WatchTheme.surface)
        )
    }
}
