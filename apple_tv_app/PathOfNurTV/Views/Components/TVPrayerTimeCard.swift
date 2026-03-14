import SwiftUI

struct TVPrayerTimeCard: View {
    let prayer: TVPrayerSummary

    private var accent: Color {
        switch prayer.state {
        case .current: return TVTheme.focus
        case .upcoming: return TVTheme.accent
        case .completed: return TVTheme.textTertiary
        }
    }

    private var stateLabel: String {
        switch prayer.state {
        case .current: return "Current"
        case .upcoming: return "Upcoming"
        case .completed: return "Completed"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(prayer.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(TVTheme.textPrimary)
                    Text(prayer.arabicName)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(TVTheme.textSecondary)
                }
                Spacer()
                Text(stateLabel)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(accent.opacity(0.14), in: Capsule())
            }
            Text(prayer.timeLabel)
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundStyle(accent)
        }
        .frame(width: 320, height: 180, alignment: .topLeading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
                .fill(TVTheme.surface)
        )
        .tvFocusableCard()
    }
}
