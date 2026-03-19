import SwiftUI

struct WatchHomeView: View {
  @EnvironmentObject private var model: WatchAppModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Text(WatchStrings.homeTitle)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
          Spacer()
          WatchSyncStatusBadge(state: model.syncBadgeState)
        }
        if let dashboard = model.dashboardState {
          WatchHeroCard(glow: dashboard.allPrayersComplete) {
            Text(dashboard.allPrayersComplete ? WatchStrings.allPrayersComplete : WatchStrings.nextPrayerTitle)
              .font(.caption2.weight(.semibold))
              .foregroundStyle(WatchTheme.secondaryText)
            Text(dashboard.nextPrayerName)
              .font(.system(size: 18, weight: .bold, design: .rounded))
              .foregroundStyle(.white)
            if let nextPrayerTime = dashboard.nextPrayerTime, !dashboard.allPrayersComplete {
              VStack(alignment: .leading, spacing: 2) {
                Text(nextPrayerTime, style: .time)
                  .font(.headline)
                  .foregroundStyle(WatchTheme.accentSoft)
                Text(freshnessLabel(for: dashboard))
                  .font(.caption2)
                  .foregroundStyle(dashboard.isStale ? WatchTheme.warning : WatchTheme.secondaryText)
              }
            }
            HStack(spacing: 12) {
              WatchMiniProgressRing(
                progress: dashboard.progressValue,
                label: "\(dashboard.completedPrayerCount)/\(dashboard.totalPrayerCount)"
              )
              VStack(alignment: .leading, spacing: 6) {
                Text(WatchStrings.prayerSummary)
                  .font(.caption2)
                  .foregroundStyle(WatchTheme.secondaryText)
                Text("\(dashboard.completedPrayerCount)/\(dashboard.totalPrayerCount)")
                  .font(.system(size: 20, weight: .bold, design: .rounded))
                  .foregroundStyle(.white)
                Text("\(WatchStrings.streak): \(dashboard.streakDays)")
                  .font(.caption2)
                  .foregroundStyle(WatchTheme.accentSoft)
              }
            }
          }

          HStack(spacing: 8) {
            WatchQuickActionButton(
              title: WatchStrings.prayerTitle,
              systemImage: "checkmark.circle"
            ) {
              model.selectedTab = .prayer
            }
            WatchQuickActionButton(
              title: WatchStrings.dhikrTitle,
              systemImage: "hand.tap"
            ) {
              model.selectedTab = .dhikr
            }
            WatchQuickActionButton(
              title: WatchStrings.progressTitle,
              systemImage: "sparkles"
            ) {
              model.selectedTab = .progress
            }
          }
        } else {
          WatchHeroCard {
            Text(WatchStrings.noSnapshotTitle)
              .font(.headline)
              .foregroundStyle(.white)
            Text(WatchStrings.noSnapshotBody)
              .font(.caption2)
              .foregroundStyle(WatchTheme.secondaryText)
          }
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
    }
    .containerBackground(WatchTheme.backgroundGradient, for: .navigation)
  }

  private func freshnessLabel(for dashboard: WatchDashboardState) -> String {
    guard let lastSyncAt = dashboard.lastSyncAt else {
      return WatchStrings.freshnessNeedsSync
    }
    if dashboard.isStale {
      return WatchStrings.freshnessNeedsSync
    }
    if Date().timeIntervalSince(lastSyncAt) < 60 {
      return "\(WatchStrings.freshnessUpdated) \(WatchStrings.freshnessJustNow)"
    }
    return "\(WatchStrings.freshnessUpdated) \(lastSyncAt.formatted(.relative(presentation: .named)))"
  }
}

#Preview {
  WatchHomeView()
    .environmentObject(WatchAppModel())
}
