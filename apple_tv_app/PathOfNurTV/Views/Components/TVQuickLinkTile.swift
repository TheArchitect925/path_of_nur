import SwiftUI

struct TVQuickLinkTile: View {
    let link: TVQuickLink

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: link.systemImage)
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(TVTheme.focus)
            Text(link.title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(TVTheme.textPrimary)
            Text(link.subtitle)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(TVTheme.textSecondary)
                .lineLimit(2)
        }
        .frame(width: 300, height: 180, alignment: .topLeading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
                .fill(TVTheme.surface)
        )
        .tvFocusableCard()
    }
}
