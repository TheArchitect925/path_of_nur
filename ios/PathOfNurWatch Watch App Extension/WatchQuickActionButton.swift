import SwiftUI

struct WatchQuickActionButton: View {
  let title: String
  let systemImage: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 6) {
        Image(systemName: systemImage)
          .font(.system(size: 16, weight: .semibold))
        Text(title)
          .font(.caption2.weight(.semibold))
          .lineLimit(1)
      }
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity, minHeight: 58)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(WatchTheme.card)
      )
    }
    .buttonStyle(.plain)
  }
}
