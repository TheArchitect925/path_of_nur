import SwiftUI

/// Moves each prayer a few minutes from the time calculated, to match the
/// local mosque, and sets when Jumu'ah is prayed. As on the phone, no prayer
/// moves more than half an hour.
struct TVPrayerAdjustScreen: View {
  @ObservedObject var prayerService: TVPrayerService
  var onClose: () -> Void

  @FocusState private var focused: String?
  @State private var focusSeeker = TVFocusSeeker()

  static let prefix = "settings.prayer.adjust."

  var body: some View {
    ZStack {
      TVCoverBackground()

      VStack(alignment: .leading, spacing: 22) {
        Text(tvLocalized("Adjust prayer times"))
          .font(TVTypography.compactHeroTitle)
          .foregroundColor(TVTheme.textPrimary)
          .tvReadableTitle()

        Text(tvLocalized("Move a prayer by a few minutes to match your mosque. Each can move up to half an hour."))
          .font(TVTypography.figtreeMedium(22))
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()

        VStack(spacing: 14) {
          ForEach(TVPrayerService.adjustablePrayers, id: \.self) { prayer in
            row(
              title: Self.name(prayer),
              time: prayerService.timeLabel(for: prayer),
              value: offsetLine(prayerService.offset(for: prayer)),
              id: prayer,
              step: 1
            ) { delta in
              prayerService.adjust(prayer, by: delta)
            }
          }

          row(
            title: tvLocalized("Jumu’ah"),
            time: "",
            value: prayerService.jumuahLabel(),
            id: "jumuah",
            step: 15
          ) { delta in
            prayerService.adjustJumuah(by: delta)
          }
        }
        .focusSection()

        Button {
          prayerService.resetOffsets()
        } label: {
          Label(tvLocalized("Use the times as calculated"), systemImage: "arrow.uturn.backward")
            .font(TVTypography.figtreeMedium(22))
            .foregroundColor(TVTheme.textPrimary)
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(TVTheme.surfaceSoft, in: Capsule())
        }
        .buttonStyle(TVCardButtonStyle(shape: .capsule))
        .tvFocusID($focused, "\(Self.prefix)reset")
      }
      .frame(maxWidth: 1300, alignment: .leading)
      .padding(.horizontal, 90)
      .padding(.vertical, 60)
    }
    .onAppear {
      focusSeeker.seek("\(Self.prefix)fajr.later", with: $focused)
    }
    .onExitCommand {
      onClose()
    }
  }

  static func name(_ prayer: String) -> String {
    switch prayer {
    case "fajr": return tvLocalized("Fajr")
    case "dhuhr": return tvLocalized("Dhuhr")
    case "asr": return tvLocalized("Asr")
    case "maghrib": return tvLocalized("Maghrib")
    default: return tvLocalized("Isha")
    }
  }

  private func offsetLine(_ minutes: Int) -> String {
    if minutes == 0 {
      return tvLocalized("As calculated")
    }
    return minutes > 0
      ? tvLocalized("%d min later", minutes)
      : tvLocalized("%d min earlier", -minutes)
  }

  private func row(
    title: String,
    time: String,
    value: String,
    id: String,
    step: Int,
    change: @escaping (Int) -> Void
  ) -> some View {
    HStack(spacing: 20) {
      Text(title)
        .font(TVTypography.figtreeMedium(28))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: 220, alignment: .leading)

      Text(time)
        .font(TVTypography.figtreeMedium(26))
        .foregroundColor(TVTheme.textSecondary)
        .frame(width: 180, alignment: .leading)

      Spacer(minLength: 12)

      stepButton("minus", id: "\(Self.prefix)\(id).earlier", label: tvLocalized("Earlier")) {
        change(-step)
      }

      Text(value)
        .font(TVTypography.figtreeMedium(26))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: 260)
        .accessibilityIdentifier("\(Self.prefix)\(id).value")

      stepButton("plus", id: "\(Self.prefix)\(id).later", label: tvLocalized("Later")) {
        change(step)
      }
    }
    .padding(.horizontal, 28)
    .padding(.vertical, 14)
    .background(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(TVTheme.surfaceSoft)
    )
    .accessibilityElement(children: .contain)
  }

  private func stepButton(
    _ symbol: String,
    id: String,
    label: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: symbol)
        .font(.system(size: 22, weight: .bold))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: 62, height: 62)
        .background(Circle().fill(TVTheme.surface))
    }
    .buttonStyle(TVCardButtonStyle(shape: .capsule))
    .tvFocusID($focused, id)
    .accessibilityLabel(label)
  }
}
