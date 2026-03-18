import SwiftUI

struct WatchHomeView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        Text("Path of Nūr")
          .font(.headline)

        Text("Watch companion scaffold")
          .font(.subheadline)
          .foregroundStyle(.secondary)

        Text("This native watch target is intentionally minimal. It is ready to grow into prayer status, dhikr, and quick-action surfaces without overloading the iOS target.")
          .font(.footnote)

        Divider()

        VStack(alignment: .leading, spacing: 8) {
          Label("Prayer status", systemImage: "clock")
          Label("Dhikr shortcuts", systemImage: "hands.sparkles")
          Label("Quick actions", systemImage: "bolt")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
    }
  }
}

#Preview {
  WatchHomeView()
}
