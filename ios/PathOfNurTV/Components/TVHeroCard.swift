import SwiftUI

struct TVHeroCard: View {
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      if !eyebrow.isEmpty {
        Text(eyebrow.uppercased())
          .font(TVTypography.heroEyebrow)
          .foregroundColor(TVTheme.focus)
          .tvReadableBody()
      }

      Text(title)
        .font(TVTypography.heroTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      if !subtitle.isEmpty {
        Text(subtitle)
          .font(TVTypography.heroSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .frame(maxWidth: 980, alignment: .leading)
          .tvReadableBody()
      }

      if !supportingLine.isEmpty {
        Text(supportingLine)
          .font(TVTypography.heroSupporting)
          .foregroundColor(TVTheme.textMuted)
          .tvReadableBody()
      }
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
      label: subtitle.isEmpty ? title : "\(title). \(subtitle)",
      hint: supportingLine
    )
  }
}

/// The hero of a screen that keeps its height for what is read below it: one
/// line of title, one of subtitle, and the screen's own controls beside them.
struct TVCompactHeroCard<Accessory: View>: View {
  let title: String
  let subtitle: String
  @ViewBuilder var accessory: () -> Accessory

  var body: some View {
    HStack(alignment: .center, spacing: 24) {
      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(TVTypography.compactHeroTitle)
          .foregroundColor(TVTheme.textPrimary)
          .lineLimit(1)

        if !subtitle.isEmpty {
          Text(subtitle)
            .font(TVTypography.sectionSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(1)
        }
      }
      .tvCombinedAccessibility(
        label: subtitle.isEmpty ? title : "\(title). \(subtitle)"
      )

      Spacer(minLength: 24)

      accessory()
    }
    .padding(.horizontal, 28)
    .padding(.vertical, 14)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
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
          RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
            .stroke(TVTheme.surfaceStroke, lineWidth: 1)
        )
        .shadow(color: TVTheme.surfaceShadow, radius: 18, x: 0, y: 8)
    )
  }
}
