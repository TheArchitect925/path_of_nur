import SwiftUI

struct WatchPrayerRow: View {
  @Environment(\.watchPalette) private var palette
  let prayer: WatchPrayerPayload
  var isFocused: Bool = false

  var body: some View {
    HStack(spacing: 10) {
      VStack(alignment: .leading, spacing: 2) {
        Text(prayer.displayName)
          .font(.system(size: 15, weight: .semibold, design: .serif))
          .foregroundStyle(palette.onSurface)
        Text(prayer.scheduledTime, style: .time)
          .font(WatchType.caption)
          .foregroundStyle(palette.onSurfaceSubtle)
      }
      Spacer()
      VStack(alignment: .trailing, spacing: 3) {
        Text(statusLabel)
          .font(WatchType.captionEmphasis)
          .foregroundStyle(statusColor)
        Image(systemName: statusSymbol)
          .font(.system(size: 18, weight: .semibold))
          .foregroundStyle(statusColor)
      }
    }
    .padding(.vertical, 6)
    .padding(.horizontal, 4)
    .background(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(isFocused ? palette.accent.opacity(0.16) : Color.clear)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .strokeBorder(
          isFocused ? palette.accent.opacity(0.8) : Color.clear,
          lineWidth: 1
        )
    )
  }

  private var statusLabel: String {
    switch prayer.status {
    case .pending:
      return WatchStrings.pending
    case .completed:
      return prayer.timing == WatchPrayerTimingValue.late.rawValue
          ? WatchStrings.late
          : WatchStrings.completed
    case .missed:
      return WatchStrings.missedStatus
    }
  }

  private var statusColor: Color {
    switch prayer.status {
    case .pending:
      return palette.onSurfaceSubtle
    case .completed:
      return palette.success
    case .missed:
      return palette.warning
    }
  }

  private var statusSymbol: String {
    switch prayer.status {
    case .pending:
      return "circle"
    case .completed:
      return "checkmark.circle.fill"
    case .missed:
      return "xmark.circle.fill"
    }
  }
}
