import SwiftUI

struct PrayerCheckInScreen: View {
    @EnvironmentObject private var store: WatchAppStore

    var body: some View {
        List {
            ForEach(store.prayers) { prayer in
                Button {
                    store.markPrayer(prayer.prayerId, completed: prayer.status == .pending)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(prayer.displayName)
                            Text(prayer.scheduledTime.formatted(date: .omitted, time: .shortened))
                                .font(.caption2)
                                .foregroundStyle(WatchTheme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: prayer.status == .completed ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(prayer.status == .completed ? WatchTheme.positive : WatchTheme.textSecondary)
                    }
                }
            }
        }
        .listStyle(.carousel)
    }
}
