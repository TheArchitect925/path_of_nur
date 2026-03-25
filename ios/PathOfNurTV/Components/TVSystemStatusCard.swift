import SwiftUI

struct TVSystemStatusCard: View {
  let snapshot: TVSystemStatusSnapshot

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .top, spacing: 14) {
        VStack(alignment: .leading, spacing: 8) {
          Text(snapshot.eyebrow.uppercased())
            .font(TVTypography.badge)
            .foregroundColor(TVTheme.focus)
            .tvReadableBody()

          Text(snapshot.title)
            .font(TVTypography.sectionTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          Text(snapshot.subtitle)
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.textSecondary)
            .tvReadableBody()
        }

        Spacer(minLength: 0)

        Image(systemName: snapshot.systemImage)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }

      if !snapshot.chips.isEmpty {
        HStack(spacing: 10) {
          ForEach(snapshot.chips, id: \.self) { chip in
            Text(chip)
              .font(TVTypography.badge)
              .foregroundColor(TVTheme.textPrimary)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(
                Capsule(style: .continuous)
                  .fill(TVTheme.surfaceSoft)
              )
          }
        }
      }

      Text(snapshot.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .tvReadableBody()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(20)
    .tvSurfaceCard(elevated: false, emphasized: false)
    .tvCombinedAccessibility(
      label: snapshot.title,
      hint: snapshot.subtitle,
      value: snapshot.chips.joined(separator: ", ")
    )
  }
}
