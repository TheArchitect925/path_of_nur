import SwiftUI

struct WatchMiniProgressRing: View {
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
        .stroke(WatchTheme.cardBorder, lineWidth: lineWidth)
      Circle()
        .trim(from: 0, to: min(max(progress, 0), 1))
        .stroke(
          AngularGradient(
            colors: [WatchTheme.accentSoft, WatchTheme.accent],
            center: .center
          ),
          style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        )
        .rotationEffect(.degrees(-90))
      Text(label)
        .font(.system(size: 13, weight: .semibold, design: .rounded))
        .foregroundStyle(.white)
    }
    .frame(width: 56, height: 56)
  }
}
