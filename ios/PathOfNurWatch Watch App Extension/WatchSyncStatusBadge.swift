import SwiftUI

struct WatchSyncStatusBadge: View {
  @Environment(\.watchPalette) private var palette
  let state: WatchSyncBadgeState

  var body: some View {
    HStack(spacing: 5) {
      Circle()
        .fill(color)
        .frame(width: 6, height: 6)
      Text(label)
        .font(WatchType.caption)
        .foregroundStyle(palette.onSurfaceMuted)
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
      return palette.success
    case .cached:
      return palette.accentSoft
    case .pending:
      return palette.warning
    }
  }
}
