import SwiftUI

struct WatchMiniProgressRing: View {
  @Environment(\.watchPalette) private var palette
  let progress: Double
  let lineWidth: CGFloat
  let label: String

  init(progress: Double, lineWidth: CGFloat = 8, label: String) {
    self.progress = progress
    self.lineWidth = lineWidth
    self.label = label
  }

  var body: some View {
    ZStack {
      Circle()
        .stroke(palette.divider, lineWidth: lineWidth)
      Circle()
        .trim(from: 0, to: min(max(progress, 0), 1))
        .stroke(
          AngularGradient(
            colors: [palette.accentSoft, palette.accent],
            center: .center
          ),
          style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        )
        .rotationEffect(.degrees(-90))
      Text(label)
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(palette.onSurface)
    }
    .frame(width: 56, height: 56)
  }
}
