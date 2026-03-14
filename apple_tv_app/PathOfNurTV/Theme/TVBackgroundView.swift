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
                .fill(TVTheme.accent.opacity(0.16))
                .frame(width: 520, height: 520)
                .blur(radius: 90)
                .offset(x: 420, y: -280)
            Circle()
                .fill(TVTheme.focus.opacity(0.12))
                .frame(width: 460, height: 460)
                .blur(radius: 96)
                .offset(x: -500, y: 260)
        }
        .ignoresSafeArea()
    }
}
