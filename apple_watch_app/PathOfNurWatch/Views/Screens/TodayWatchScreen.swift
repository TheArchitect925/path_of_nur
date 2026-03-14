import SwiftUI

struct TodayWatchScreen: View {
    @EnvironmentObject private var store: WatchAppStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Today")
                    .font(.title2.bold())
                    .foregroundStyle(WatchTheme.textPrimary)
                Text("Next prayer")
                    .font(.caption)
                    .foregroundStyle(WatchTheme.textSecondary)
                Text(store.snapshot.nextPrayerId.capitalized)
                    .font(.title3.bold())
                    .foregroundStyle(WatchTheme.accent)
                Text(store.snapshot.nextPrayerTime.formatted(date: .omitted, time: .shortened))
                    .foregroundStyle(WatchTheme.textPrimary)
                HStack {
                    WatchStatCard(title: "Prayers", value: "\(store.snapshot.completedPrayerCount)/\(store.snapshot.totalPrayerCount)")
                    WatchStatCard(title: "Dhikr", value: "\(store.snapshot.dhikrTodayCount)")
                }
                HStack {
                    WatchStatCard(title: "Streak", value: "\(store.snapshot.streakDays)")
                    WatchStatCard(title: "Drops", value: "\(store.snapshot.oceanDropsToday)")
                }
                Link(destination: WatchSharedConstants.routeURL(.quranAudio)) {
                    Text("Qur’an Audio")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                if let lastSyncAt = store.snapshot.lastSyncAt {
                    Text("Synced \(lastSyncAt.formatted(date: .omitted, time: .shortened))")
                        .font(.caption2)
                        .foregroundStyle(WatchTheme.textSecondary)
                } else if !store.queue.isEmpty {
                    Text("Offline changes saved")
                        .font(.caption2)
                        .foregroundStyle(WatchTheme.textSecondary)
                }
            }
            .padding()
        }
        .containerBackground(WatchTheme.background, for: .navigation)
    }
}
