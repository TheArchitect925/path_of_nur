import SwiftUI

struct TVHomeView: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color.black, Color(red: 0.05, green: 0.12, blue: 0.18)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(alignment: .leading, spacing: 24) {
        Text("Path of Nūr")
          .font(.system(size: 56, weight: .bold, design: .serif))

        Text("tvOS scaffold")
          .font(.title2)
          .foregroundStyle(.secondary)

        Text("This native tvOS target is intentionally minimal. It creates a real Apple TV app shell that can evolve into a focused large-screen experience without overloading the iOS target.")
          .font(.title3)
          .frame(maxWidth: 900, alignment: .leading)

        HStack(spacing: 20) {
          featurePill("Prayer view")
          featurePill("Qur'an audio")
          featurePill("Ambient learning")
        }
      }
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
      .padding(80)
    }
  }

  private func featurePill(_ title: String) -> some View {
    Text(title)
      .font(.headline)
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
      .background(Color.white.opacity(0.12), in: Capsule())
  }
}

#Preview {
  TVHomeView()
}
