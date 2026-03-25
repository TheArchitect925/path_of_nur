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

      RoundedRectangle(cornerRadius: 240, style: .continuous)
        .fill(
          LinearGradient(
            colors: [
              TVTheme.backgroundMeshTop.opacity(0.20),
              TVTheme.backgroundMeshBottom.opacity(0.08),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .frame(width: 860, height: 360)
        .blur(radius: 72)
        .offset(x: -260, y: -300)

      Circle()
        .fill(TVTheme.focus.opacity(0.12))
        .frame(width: 420, height: 420)
        .blur(radius: 96)
        .offset(x: -520, y: 280)

      RoundedRectangle(cornerRadius: 260, style: .continuous)
        .stroke(Color.white.opacity(0.08), lineWidth: 1)
        .frame(width: 1480, height: 820)
        .blur(radius: 0.6)
    }
    .ignoresSafeArea()
  }
}
