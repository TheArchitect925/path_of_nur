import SwiftUI

struct TVPrayerTimeCard: View {
  let prayer: TVPrayerTime

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: 4) {
          Text(prayer.title)
            .font(.system(size: 26, weight: .bold, design: .serif))
            .foregroundStyle(TVTheme.textPrimary)

          Text(prayer.arabicTitle)
            .font(.system(size: 22, weight: .semibold, design: .serif))
            .foregroundStyle(TVTheme.textSecondary)
        }

        Spacer()

        if prayer.isCurrent {
          Text(NSLocalizedString("Current", comment: ""))
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(TVTheme.prayerCurrentText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(TVTheme.prayerCurrent, in: Capsule())
        } else if prayer.isNext {
          Text(NSLocalizedString("Next", comment: ""))
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(TVTheme.prayerNextText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(TVTheme.prayerNext, in: Capsule())
        }
      }

      Text(prayer.timeLabel)
        .font(.system(size: 34, weight: .heavy, design: .rounded))
        .foregroundStyle(TVTheme.textPrimary)

      Text(prayer.statusLine)
        .font(.system(size: 18, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(24)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .fill(prayer.isCurrent ? TVTheme.surfaceElevated : TVTheme.surface)
    )
    .tvFocusableCard()
  }
}
