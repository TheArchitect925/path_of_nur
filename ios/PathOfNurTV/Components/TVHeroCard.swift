import SwiftUI

struct TVHeroCard: View {
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(eyebrow.uppercased())
        .font(.system(size: 16, weight: .semibold, design: .rounded))
        .foregroundStyle(TVTheme.focus)

      Text(title)
        .font(.system(size: 64, weight: .bold, design: .serif))
        .foregroundStyle(TVTheme.textPrimary)

      Text(subtitle)
        .font(.system(size: 26, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
        .frame(maxWidth: 980, alignment: .leading)

      Text(supportingLine)
        .font(.system(size: 20, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textMuted)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(40)
    .background(
      RoundedRectangle(cornerRadius: 36, style: .continuous)
        .fill(TVTheme.surface)
    )
  }
}
