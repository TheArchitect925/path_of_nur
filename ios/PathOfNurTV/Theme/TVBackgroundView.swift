import SwiftUI

struct TVBackgroundView: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [TVTheme.backgroundTop, TVTheme.backgroundBottom],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )

      Circle()
        .fill(TVTheme.accentSoft.opacity(0.28))
        .frame(width: 560, height: 560)
        .blur(radius: 100)
        .offset(x: 420, y: -260)

      Circle()
        .fill(TVTheme.focus.opacity(0.12))
        .frame(width: 420, height: 420)
        .blur(radius: 96)
        .offset(x: -520, y: 280)
    }
    .ignoresSafeArea()
  }
}
