import SwiftUI

struct TVHouseholdProfileCardView: View {
  let profile: TVHouseholdProfile
  let isSelected: Bool
  let isActive: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack(alignment: .top) {
        Text(profile.avatar)
          .font(.system(size: 40))
          .frame(width: 64, height: 64)
          .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
              .fill(TVTheme.surfaceSoft)
          )

        Spacer(minLength: 12)

        VStack(alignment: .trailing, spacing: 8) {
          chip(profile.audienceLabel)
          if isActive {
            chip(tvLocalized("Active"))
          }
        }
      }

      VStack(alignment: .leading, spacing: 8) {
        Text(profile.title)
          .font(TVTypography.sectionTitle)
          .foregroundColor(isSelected ? TVTheme.accentStrong : TVTheme.textPrimary)
          .tvReadableTitle()

        Text(profile.subtitle)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()

        Text(profile.supportingLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)
          .tvReadableBody()
      }
    }
    .frame(width: 360, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isSelected || isActive)
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: profile.title,
      hint: profile.subtitle,
      value: isActive ? tvLocalized("Active") : nil
    )
  }

  private func chip(_ text: String) -> some View {
    Text(text)
      .font(TVTypography.detail)
      .foregroundColor(TVTheme.textPrimary)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(
        Capsule(style: .continuous)
          .fill(TVTheme.surfaceSoft)
      )
  }
}
