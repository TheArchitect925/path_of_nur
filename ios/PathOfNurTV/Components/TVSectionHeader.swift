import SwiftUI

struct TVSectionHeader: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(subtitle)
        .font(TVTypography.sectionSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .frame(maxWidth: 920, alignment: .leading)
        .tvReadableBody()
    }
    .tvCombinedAccessibility(label: title, hint: subtitle)
  }
}
