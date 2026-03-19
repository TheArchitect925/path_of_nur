import SwiftUI

struct WatchPrayerRow: View {
  let prayer: WatchPrayerPayload
  var isFocused: Bool = false

  var body: some View {
    HStack(spacing: 10) {
      VStack(alignment: .leading, spacing: 2) {
        Text(prayer.displayName)
          .font(.system(size: 15, weight: .semibold, design: .rounded))
          .foregroundStyle(.white)
        Text(prayer.scheduledTime, style: .time)
          .font(.caption2)
          .foregroundStyle(WatchTheme.secondaryText)
      }
      Spacer()
      VStack(alignment: .trailing, spacing: 3) {
        Text(statusLabel)
          .font(.caption2.weight(.semibold))
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
        .fill(isFocused ? WatchTheme.cardHighlight : Color.clear)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .stroke(
          isFocused ? WatchTheme.accent.opacity(0.8) : Color.clear,
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
      return WatchTheme.secondaryText
    case .completed:
      return WatchTheme.success
    case .missed:
      return WatchTheme.warning
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
