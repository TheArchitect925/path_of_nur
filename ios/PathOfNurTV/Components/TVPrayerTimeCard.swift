import SwiftUI

struct TVPrayerTimeCard: View {
  let prayer: TVPrayerTime

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: 4) {
          Text(prayer.title)
            .font(TVTypography.featureTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          Text(prayer.arabicTitle)
            .font(TVTypography.arabicSupport)
            .foregroundColor(TVTheme.textSecondary)
            .tvReadableArabic()
        }

        Spacer()

        if prayer.isCurrent {
          Text(tvLocalized("Current"))
            .font(TVTypography.badge)
            .foregroundColor(TVTheme.prayerCurrentText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(TVTheme.prayerCurrent, in: Capsule())
        } else if prayer.isNext {
          Text(tvLocalized("Next"))
            .font(TVTypography.badge)
            .foregroundColor(TVTheme.prayerNextText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(TVTheme.prayerNext, in: Capsule())
        }
      }

      Text(prayer.timeLabel)
        .font(.system(size: 36, weight: .heavy, design: .rounded))
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(prayer.statusLine)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(24)
    .tvSurfaceCard(elevated: prayer.isCurrent, emphasized: prayer.isCurrent || prayer.isNext)
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: "\(prayer.title), \(prayer.timeLabel)",
      hint: prayer.statusLine,
      value: prayer.isCurrent ? tvLocalized("Current") : (prayer.isNext ? tvLocalized("Next") : nil)
    )
  }
}
