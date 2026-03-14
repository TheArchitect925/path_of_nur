import SwiftUI

struct TVHeroBanner: View {
    let title: String
    let subtitle: String
    let eyebrow: String
    let supportingLine: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 38, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [TVTheme.accent.opacity(0.32), TVTheme.surface],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 38, style: .continuous)
                        .stroke(TVTheme.focus.opacity(0.22), lineWidth: 1.5)
                )
            VStack(alignment: .leading, spacing: 10) {
                Text(eyebrow.uppercased())
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(TVTheme.focus)
                Text(title)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(TVTheme.textPrimary)
                    .lineLimit(2)
                Text(subtitle)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundStyle(TVTheme.textSecondary)
                    .lineLimit(2)
                Text(supportingLine)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundStyle(TVTheme.textTertiary)
            }
            .padding(40)
        }
        .frame(height: 340)
    }
}
