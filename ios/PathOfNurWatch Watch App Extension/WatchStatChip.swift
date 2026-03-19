import SwiftUI

struct WatchStatChip: View {
  let title: String
  let value: String

  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(title.uppercased())
        .font(.system(size: 9, weight: .bold, design: .rounded))
        .foregroundStyle(WatchTheme.secondaryText)
      Text(value)
        .font(.system(size: 15, weight: .semibold, design: .rounded))
        .foregroundStyle(.white)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .fill(WatchTheme.card)
    )
  }
}
