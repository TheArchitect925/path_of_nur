import SwiftUI

struct WatchSyncStatusBadge: View {
  let state: WatchSyncBadgeState

  var body: some View {
    HStack(spacing: 5) {
      Circle()
        .fill(color)
        .frame(width: 6, height: 6)
      Text(label)
        .font(.caption2.weight(.semibold))
        .foregroundStyle(WatchTheme.secondaryText)
    }
  }

  private var label: String {
    switch state {
    case .live:
      return WatchStrings.liveBadge
    case .cached:
      return WatchStrings.cachedBadge
    case .pending(let count):
      return "\(WatchStrings.pendingBadge) \(count)"
    }
  }

  private var color: Color {
    switch state {
    case .live:
      return WatchTheme.success
    case .cached:
      return WatchTheme.accent
    case .pending:
      return WatchTheme.warning
    }
  }
}
