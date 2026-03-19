import SwiftUI

struct TVSectionHeader: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 34, weight: .bold, design: .rounded))
        .foregroundStyle(TVTheme.textPrimary)

      Text(subtitle)
        .font(.system(size: 19, weight: .medium, design: .rounded))
        .foregroundStyle(TVTheme.textSecondary)
        .frame(maxWidth: 920, alignment: .leading)
    }
  }
}
