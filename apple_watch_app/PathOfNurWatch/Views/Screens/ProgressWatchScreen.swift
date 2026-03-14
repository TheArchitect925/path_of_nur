import SwiftUI

struct ProgressWatchScreen: View {
    @EnvironmentObject private var store: WatchAppStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Progress")
                    .font(.headline)
                WatchStatCard(title: "Prayers", value: "\(store.snapshot.completedPrayerCount)/\(store.snapshot.totalPrayerCount)")
                WatchStatCard(title: "Dhikr", value: "\(store.snapshot.dhikrTodayCount)")
                WatchStatCard(title: "Streak", value: "\(store.snapshot.streakDays)")
                WatchStatCard(title: "XP", value: "\(store.snapshot.xpToday)")
                WatchStatCard(title: "Ocean Drops", value: "\(store.snapshot.oceanDropsToday)")
                WatchStatCard(
                    title: "Sync",
                    value: store.queue.isEmpty ? "Up to date" : "Pending \(store.queue.count)"
                )
            }
            .padding()
        }
    }
}
