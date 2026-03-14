import SwiftUI

struct TVProgressSummaryCard: View {
    let summary: TVProgressSummary

    var body: some View {
        HStack(spacing: 28) {
            ZStack {
                Circle()
                    .stroke(TVTheme.surface, lineWidth: 18)
                Circle()
                    .trim(from: 0, to: summary.completionRing)
                    .stroke(TVTheme.focus, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 4) {
                    Text("\(Int(summary.completionRing * 100))%")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(TVTheme.textPrimary)
                    Text("today")
                        .foregroundStyle(TVTheme.textSecondary)
                }
            }
            .frame(width: 180, height: 180)

            VStack(alignment: .leading, spacing: 12) {
                Text("Progress Overview")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(TVTheme.textPrimary)
                Text("Prayer streak: \(summary.prayerStreak) days")
                    .foregroundStyle(TVTheme.textSecondary)
                Text("Learning sessions: \(summary.learningSessions)")
                    .foregroundStyle(TVTheme.textSecondary)
                Text("Ocean Drops: \(summary.oceanDrops)")
                    .foregroundStyle(TVTheme.textSecondary)
                Text("Reflections: \(summary.reflectionCount)")
                    .foregroundStyle(TVTheme.textSecondary)
            }
            Spacer()
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(TVTheme.surface)
        )
    }
}
