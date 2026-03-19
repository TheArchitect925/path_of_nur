import SwiftUI

struct TVActionCard: View {
  let title: String
  let subtitle: String
  let systemImage: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Image(systemName: systemImage)
        .font(.system(size: 30, weight: .semibold))
        .foregroundStyle(TVTheme.accentStrong)

      Text(title)
        .font(.system(size: 28, weight: .bold, design: .serif))
        .foregroundStyle(TVTheme.textPrimary)

      Text(subtitle)
        .font(.system(size: 18, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
        .lineLimit(3)
    }
    .frame(width: 340, height: 214, alignment: .leading)
    .padding(28)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .fill(TVTheme.surface)
    )
    .tvFocusableCard()
  }
}
