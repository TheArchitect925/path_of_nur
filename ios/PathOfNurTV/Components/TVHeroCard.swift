import SwiftUI

struct TVHeroCard: View {
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(eyebrow.uppercased())
        .font(TVTypography.heroEyebrow)
        .foregroundColor(TVTheme.focus)
        .tvReadableBody()

      Text(title)
        .font(TVTypography.heroTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(subtitle)
        .font(TVTypography.heroSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .frame(maxWidth: 980, alignment: .leading)
        .tvReadableBody()

      Text(supportingLine)
        .font(TVTypography.heroSupporting)
        .foregroundColor(TVTheme.textMuted)
        .tvReadableBody()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.heroPadding)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.heroRadius, style: .continuous)
        .fill(
          LinearGradient(
            colors: [
              TVTheme.surfaceElevated,
              TVTheme.surface,
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .overlay(
          RoundedRectangle(cornerRadius: TVTheme.heroRadius, style: .continuous)
            .stroke(TVTheme.surfaceStroke, lineWidth: 1)
        )
        .shadow(color: TVTheme.surfaceShadow, radius: 22, x: 0, y: 10)
    )
    .tvCombinedAccessibility(
      label: "\(title). \(subtitle)",
      hint: supportingLine
    )
  }
}
